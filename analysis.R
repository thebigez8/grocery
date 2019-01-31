library(tidyverse)
library(arsenal)
library(lme4)
library(lmerTest)
# how many times per month do we buy this item
freqs <- c(
  "Apples (Fuji)" = 1,
  "Apples (Honeycrisp)" = 1,
  "Applesauce"    = 1,
  "Bananas"       = 2,
  "Beef (80%)"    = 3,
  "Black Beans"   = 1,
  "Blueberries"   = 1,
  "Bread"         = 2,
  "Broccoli (frozen)" = 1,
  "Butter"        = 2,
  "Cheese"        = 4,
  "Chicken"       = 2,
  "Chicken Strips"= 2,
  "Chocolate Chips" = 1,
  "Clementines"   = 1,
  "Crackers"      = 2,
  "Cucumber"      = 2,
  "Deli Ham"      = 1,
  "Deli Turkey"   = 1,
  "Eggs"          = 4,
  "Flour"         = 1/12,
  "Green Pepper"  = 1,
  "Ice Cream"     = 2,
  "Jelly"         = 0.5,
  "Ketchup"       = 0.25,
  "Lettuce"       = 1,
  "M&C (Annie's)" = 6,
  "Milk (2%)"     = 2,
  "OJ"            = 0.5,
  "Olive Oil"     = 1/6,
  "Peanut Butter" = 1,
  "Potato Chips"  = 2,
  "Red Sauce"     = 2,
  "Salsa"         = 0.25,
  "SBR's BBQ Sauce" = 0.25,
  "Spaghetti"     = 4,
  "Spinach"       = 2,
  "Strawberries"  = 2,
  "Sugar"         = 1/12,
  "Taco Seasoning" = 2,
  "Tator Tots"    = 3,
  "Tomato Soup"   = 0.25,
  "Tortilla Chips" = 0.25,
  "Tortillas"     = 1,
  "White Rice"    = 0.25
)

calc.unit <- function(x)
{
  if(length(unique(x$units)) != 1)
  {
    print(x)
    stop("Bad units")
  }
  mutate(x, PPU = Price_after_sale * min(num_units) / num_units)
}

dat <- "prices.csv" %>%
  read_csv(col_names = TRUE, col_types = cols()) %>%
  mutate(
    Units = gsub("fl oz", "floz", gsub("sq ft", "sqft", Units))
  ) %>%
  filter(is.na(Notes) & Item != "Toilet paper") %>%
  filter(!is.na(Price) & !is.na(Units)) %>%
  separate(Units, c("num_units", "units"), sep = " ") %>%
  mutate(
    num_units = as.numeric(num_units),
    Price_after_sale = case_when(
      is.na(Sale) ~ Price,
      Sale == "$0.50" ~ Price - 0.5,
      Sale == "5%" ~ Price * 0.95,
      Sale == "10%" ~ Price * 0.9,
      Sale == "15%" ~ Price * 0.85,
      Sale == "20% + $0.??" ~ Price * 0.8
    ) * if_else(Store == "Target", 0.95, 0.98),
    timepoint = factor(1 + (Date == "1/12/2019"))
  ) %>%
  group_by(Item) %>%
  do(calc.unit(.)) %>%
  ungroup() %>%
  mutate(
    wts = freqs[Item],
    PPM = PPU*wts,
    Store = factor(Store, levels = c("Aldi", "Target", "Costco", "Kwik Trip",
                                     "Walmart", "Hy-Vee", "Cub", "Trader Joe's"))
  )

p <- ggplot(dat, aes(x = Item, y = PPM, color = Store)) +
  facet_wrap(~ timepoint) +
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
