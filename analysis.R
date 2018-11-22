library(tidyverse)

# how many times per month do we buy this item
freqs <- c(
  "Apples (Fuji)" = 1,
  "Applesauce"    = 1,
  "Bananas"       = 2,
  "Beef (80%)"    = 3,
  "Bread"         = 2,
  "Butter"        = 2,
  "Cheese"        = 4,
  "Chicken"       = 2,
  "Chicken Strips"= 2,
  "Crackers"      = 2,
  "Cucumber"      = 2,
  "Deli Turkey"   = 1,
  "Eggs"          = 3,
  "Flour"         = 1/12,
  "Ice Cream"     = 2,
  "Lettuce"       = 1,
  "M&C (Annie's)" = 8,
  "Milk (2%)"     = 2,
  "OJ"            = 1,
  "Olive Oil"     = 1/6,
  "Potato Chips"  = 2,
  "Red Sauce"     = 2,
  "Spaghetti"     = 2,
  "Spinach"       = 2,
  "Strawberries"  = 2,
  "Sugar"         = 1/12,
  "Tator Tots"    = 3,
  "Toilet paper"  = 1/2
)

calc.unit <- function(x)
{
  stopifnot(length(unique(x$units)) == 1)
  mutate(x, PPU = Price_after_sale * min(num_units) / num_units)
}

dat <- "prices.csv" %>%
  read_csv(col_names = TRUE, col_types = cols()) %>%
  mutate(
    Units = gsub("fl oz", "floz", gsub("sq ft", "sqft", Units))
  ) %>%
  separate(Units, c("num_units", "units"), sep = " ") %>%
  mutate(
    num_units = as.numeric(num_units),
    Price_after_sale = case_when(
      is.na(Sale) ~ Price,
      Sale == "$0.50" ~ Price - 0.5,
      Sale == "5%" ~ Price * 0.95,
      Sale == "20% + $0.??" ~ Price * 0.8
    ) * if_else(Store == "Target", 0.95, 0.98)
  ) %>%
  group_by(Item) %>%
  do(calc.unit(.)) %>%
  ungroup() %>%
  mutate(
    PPU = replace(PPU, !is.na(Notes) | Item == "Toilet paper", NA),
    wts = freqs[Item],
    PPM = PPU*wts,
    Store = factor(Store, levels = c("Aldi", "Target", "Costco", "Walmart", "Hy-Vee"))
  )

p <- dat %>%
  select(Item, Store, PPM) %>%
  na.omit() %>%
  ggplot(aes(x = Item, y = PPM, color = Store)) +
  geom_point() +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  ylab("Price per Month (USD)") + xlab("")
print(p)
ggsave("price_per_month.png", p, width = 5, height = 4)

# summary(ppu.lm <- lm(PPU ~ Store + Item, weights = wts, data = dat, na.action = na.exclude,
#                      subset = Item != "Olive Oil"))
# dat$pred.pu <- fitted(ppu.lm)
summary(ppm.lm <- lm(PPM ~ Store + Item, data = dat, na.action = na.exclude))
dat$pred.pm <- fitted(ppm.lm)

# ppu.lm %>% summary %>% coef() %>% head(5)
ppm.lm %>% summary %>% coef() %>% head(5)


########################### SENSITIVITY ANALYSIS #########
tmpfun <- function(x)
{
  tmp <- lm(PPM ~ Store + Item, data = dat, na.action = na.exclude, subset = Item != x) %>%
    coef() %>%
    head(5)
  stopifnot(all(tmp > 0))
  tmp %>%
    "["(-1) %>%
    sort() %>%
    names()
}
sens <- names(freqs) %>%
  sapply(tmpfun) %>%
  t() %>%
  as.data.frame() %>%
  lapply(table)


options(show.signif.stars = FALSE)
capture.output(arsenal::verbatim(summary(ppm.lm)), file = "results.md")
