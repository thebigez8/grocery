library(tidyverse)
library(arsenal)
library(lme4)
library(lmerTest)
# how many times per month do we buy this item
f <- function(freq, num, units) list(freq = freq, Ref = list(num_units = num, units = units))
freqs <- list(
  "Apples (Fuji)" = f(2, 1, "lb"),
  "Apples (Honeycrisp)" = f(1, 1, "lb"),
  "Applesauce"    = f(1, 46, "oz"),
  "Bananas"       = f(2, 1, "lb"),
  "Beef (80%)"    = f(8, 1, "lb"),
  "Black Beans"   = f(1, 15, "oz"),
  "Blueberries"   = f(1, 1, "pint"),
  "Bread"         = f(2, 20, "oz"),
  "Broccoli (frozen)" = f(2, 12, "oz"),
  "Butter"        = f(2, 1, "lb"),
  "Cheese"        = f(6, 8, "oz"),
  "Chicken"       = f(4, 1, "lb"),
  "Chicken Strips"= f(3, 25, "oz"),
  "Chocolate Chips" = f(2, 12, "oz"),
  "Clementines"   = f(1, 3, "lb"),
  "Crackers"      = f(2, 13.7, "oz"),
  "Cucumber"      = f(5, 1, "cuke"),
  "Deli Ham"      = f(0.5, 16, "oz"),
  "Deli Turkey"   = f(2, 16, "oz"),
  "Eggs"          = f(4, 12, "eggs"),
  "Flour"         = f(1/3, 5, "lb"),
  "Green Pepper"  = f(0.5, 1, "peppers"),
  "Ice Cream"     = f(2, 48, "floz"),
  "Jelly"         = f(1/4, 17.5, "oz"),
  "Ketchup"       = f(0.5, 19.5, "oz"),
  "Lettuce"       = f(2, 6, "oz"),
  "M&C (Annie's)" = f(6, 6, "oz"),
  "Milk (2%)"     = f(3, 1, "gal"),
  "OJ"            = f(0.5, 59, "floz"),
  "Olive Oil"     = f(1/6, 16.9, "floz"),
  "Peanut Butter" = f(1, 16, "oz"),
  "Potato Chips"  = f(2, 8, "oz"),
  "Red Sauce"     = f(3, 15, "oz"),
  "Salsa"         = f(0.25, 12, "oz"),
  "SBR's BBQ Sauce" = f(0.25, 28, "oz"),
  "Spaghetti"     = f(3, 16, "oz"),
  "Spinach"       = f(2, 6, "oz"),
  "Strawberries"  = f(2, 16, "oz"),
  "Sugar"         = f(0.25, 4, "lb"),
  "Taco Seasoning" = f(4, 1, "packet"),
  "Tator Tots"    = f(2, 32, "oz"),
  "Tomato Soup"   = f(0.25, 10.75, "oz"),
  "Tortilla Chips" = f(0.5, 12, "oz"),
  "Tortillas"     = f(0.5, 14, "oz"),
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
    Store = factor(Store, levels = c("Aldi", "Costco", "Target", "Walmart", "Hy-Vee",
                                     "Cub", "Trader Joe's", "Kwik Trip")),
    seasonal = +(Item == "Strawberries" & timepoint == "2")
  )

#### TIMEPOINT 1 ####

p <- ggplot(filter(dat, timepoint == 1), aes(x = Item, y = PPM, color = Store)) +
  geom_point() +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  ylab("Price per Month (USD)") + xlab("")
print(p)
ggsave("price_per_month.png", p, width = 5, height = 4)

summary(ppm.lm <- lm(log(PPM) ~ Store + Item, data = dat, subset = timepoint == 1))
ppm.lm %>% summary %>% coef() %>% head(5)


#### SENSITIVITY ANALYSIS ####
tmpfun <- function(x)
{
  tmp <- lm(log(PPM) ~ Store + Item, data = dat, subset = timepoint == 1 & Item != x) %>%
    coef() %>%
    head(5)
  stopifnot(all(tmp > 0))
  tmp %>%
    "["(-1) %>%
    sort() %>%
    names()
}
sens <- names(freqs) %>%
  intersect(dat$Item[dat$timepoint == 1]) %>%
  sapply(tmpfun) %>%
  t() %>%
  as.data.frame() %>%
  lapply(table)


options(show.signif.stars = FALSE)
capture.output(arsenal::verbatim(summary(ppm.lm)), file = "results.md")







#### BOTH TIMEPOINTS ####
avg.prices <- dat %>%
  group_by(Item, Store) %>%
  summarize(PPM = mean(PPM)) %>%
  group_by(Item) %>%
  summarize(PPM = mean(PPM)) %>%
  ungroup() %>%
  arrange(PPM)
p <- ggplot(dat, aes(x = factor(Item, levels = avg.prices$Item), y = PPM, color = Store)) +
  facet_wrap(~ timepoint) +
  geom_point() +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.25, size = 7)) +
  ylab("Price per Month (USD)") + xlab("")
print(p)
ggsave("price_per_month2.png", p, width = 9, height = 5)

comp <- dat %>%
  select(Store, timepoint, PPU, Item) %>%
  spread(timepoint, PPU) %>%
  filter(!is.na(`1`) & !is.na(`2`)) %>%
  droplevels() %>%
  mutate(
    av = (`1` + `2`)/2,
    dif = `2` - `1`
  ) %>%
  arrange(-abs(dif))
ggplot(comp, aes(x = av, y = dif, color = Item)) +
  facet_wrap(~ Store) +
  geom_point()

# We could include the random interaction of item and store, but this suggests that we don't
interaction.plot(dat$Item, dat$Store, log(dat$PPM))

summary(ppm.lmer <- lmer(log(PPM) ~ Store + (1 | Item) + (1 | seasonal),
                         data = dat))
# summary(ppm.lm2 <- lm(log(PPM) ~ Store + Item + seasonal, data = dat))
plot(ppm.lmer)
ppm.lmer %>%
  summary() %>%
  coef() %>%
  as.data.frame() %>%
  rownames_to_column("term") %>%
  filter(term != "(Intercept)") %>%
  arrange(Estimate)

#### SENSITIVITY ANALYSIS ####
tmpfun.lmer <- function(x)
{
  seas <- any(dat$seasonal[dat$Item != x])
  tmp <- arsenal::formulize("log(PPM)", c("Store", "(1 | Item)", if(seas) "(1 | seasonal)")) %>%
    lmer(data = dat, subset = Item != x) %>%
    summary() %>%
    coef() %>%
    as.data.frame() %>%
    rownames_to_column("term") %>%
    (function(x) set_names(x$Estimate, x$term))

  stopifnot(all(tmp > 0))
  tmp %>%
    "["(-1) %>%
    sort() %>%
    names()
}
sens.lmer <- names(freqs) %>%
  sapply(tmpfun.lmer) %>%
  t() %>%
  as.data.frame() %>%
  lapply(table)


options(show.signif.stars = FALSE)
capture.output(arsenal::verbatim(summary(ppm.lmer)), file = "results2.md")

