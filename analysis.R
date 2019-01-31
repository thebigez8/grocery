library(tidyverse)
library(arsenal)
library(lme4)
library(lmerTest)
# how many times per month do we buy this item
f <- function(freq, num, units) list(freq = freq, Ref = list(num_units = num, units = units))
freqs <- list(
  "Apples (Fuji)" = f(1, 1, "lb"),
  "Apples (Honeycrisp)" = f(1, 1, "lb"),
  "Applesauce"    = f(1, 46, "oz"),
  "Bananas"       = f(2, 1, "lb"),
  "Beef (80%)"    = f(3, 1, "lb"),
  "Black Beans"   = f(1, 15, "oz"),
  "Blueberries"   = f(1, 1, "pint"),
  "Bread"         = f(2, 20, "oz"),
  "Broccoli (frozen)" = f(1, 12, "oz"),
  "Butter"        = f(2, 1, "lb"),
  "Cheese"        = f(4, 8, "oz"),
  "Chicken"       = f(2, 1, "lb"),
  "Chicken Strips"= f(2, 25, "oz"),
  "Chocolate Chips" = f(1, 12, "oz"),
  "Clementines"   = f(1, 3, "lb"),
  "Crackers"      = f(2, 13.7, "oz"),
  "Cucumber"      = f(2, 1, "cuke"),
  "Deli Ham"      = f(1, 16, "oz"),
  "Deli Turkey"   = f(1, 16, "oz"),
  "Eggs"          = f(4, 12, "eggs"),
  "Flour"         = f(1/12, 5, "lb"),
  "Green Pepper"  = f(1, 1, "peppers"),
  "Ice Cream"     = f(2, 48, "floz"),
  "Jelly"         = f(0.5, 17.5, "oz"),
  "Ketchup"       = f(0.25, 19.5, "oz"),
  "Lettuce"       = f(1, 6, "oz"),
  "M&C (Annie's)" = f(6, 6, "oz"),
  "Milk (2%)"     = f(2, 1, "gal"),
  "OJ"            = f(0.5, 59, "floz"),
  "Olive Oil"     = f(1/6, 16.9, "floz"),
  "Peanut Butter" = f(1, 16, "oz"),
  "Potato Chips"  = f(2, 8, "oz"),
  "Red Sauce"     = f(2, 15, "oz"),
  "Salsa"         = f(0.25, 12, "oz"),
  "SBR's BBQ Sauce" = f(0.25, 28, "oz"),
  "Spaghetti"     = f(4, 16, "oz"),
  "Spinach"       = f(2, 6, "oz"),
  "Strawberries"  = f(2, 16, "oz"),
  "Sugar"         = f(1/12, 4, "lb"),
  "Taco Seasoning" = f(2, 1, "packet"),
  "Tator Tots"    = f(3, 32, "oz"),
  "Tomato Soup"   = f(0.25, 10.75, "oz"),
  "Tortilla Chips" = f(0.25, 12, "oz"),
  "Tortillas"     = f(1, 14, "oz"),
  "White Rice"    = f(0.25, 2, "lb")
)

calc.unit <- function(x)
{
  frq <- freqs[[x$Item[1]]]
  if(!all(x$units == frq$Ref$units) ||
     !(frq$Ref$num_units %in% x$num_units))
  {
    print(x)
    stop("Bad units")
  }
  mutate(
    x,
    PPU = Price_after_sale * frq$Ref$num_units / num_units,
    wts = frq$freq,
    Ref = paste(frq$Ref$num_units, frq$Ref$units)
  )
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
    PPM = PPU*wts,
    Store = factor(Store, levels = c("Aldi", "Costco", "Target", "Kwik Trip",
                                     "Walmart", "Hy-Vee", "Cub", "Trader Joe's"))
  )

p <- ggplot(filter(dat, timepoint == 1), aes(x = Item, y = PPM, color = Store)) +
  geom_point() +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  ylab("Price per Month (USD)") + xlab("")
print(p)
ggsave("price_per_month.png", p, width = 5, height = 4)

# summary(ppu.lm <- lm(PPU ~ Store + Item, weights = wts, data = dat, na.action = na.exclude,
#                      subset = Item != "Olive Oil"))
# dat$pred.pu <- fitted(ppu.lm)
summary(ppm.lm <- lm(PPM ~ Store + Item, data = dat, subset = timepoint == 1))

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
