"

CSV to Latex:
a. Media Summary Table
b. Top 100 Coefs. for C/L
c. Out-of-sample pred. Results

"

# Set working dir.
setwd(basedir)
setwd("uk_media_ideology/")

# Load libs
library(xtable)
library(tools)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(goji)

# Read in data
media_sum <- read.csv("tabs/text/uk_media_prediction_3c.csv")
media_sum$date <- format(as.Date(media_sum$date, format='%Y-%m-%d'), format='%Y-%m-%d')
media_sum$year <- format(as.Date(media_sum$date, format='%Y-%m-%d'), format='%Y')

# Group by outlet
media_grp <- 
media_sum %>% 
group_by(news_source, year) %>% 
summarise(cons_slant = mean(pred_cons))

media_grp[grep("guardian uk", media_grp$news_source),]
media_grp[grep("the daily mail", media_grp$news_source),]
media_grp[grep("daily express", media_grp$news_source),]

# Load Twitter scores


# Plot Histogram of mean ideology of outlets

palette <- brewer.pal("Greys", n=6)

media_grp$constant <- 1

ggplot(media_grp, aes(factor(constant), cons_slant)) +
  geom_boxplot(fill=palette[3], alpha=.25, color="#cccccc") +
  theme_minimal() + 
  scale_y_continuous("Mean Ideology of Outlet\n", limits=c(0, 1), breaks=seq(0, 1, .1), labels= paste0(nolead0s(seq(0, 1, .1)), c("\nLabour", rep("", 9), "\nConservative"))) + 
  xlab("") + 
  coord_flip() + 
  theme(panel.grid.major.x = element_line(colour = "#ececec", linetype = "dotted"),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        legend.position  = "none",
        legend.key       = element_blank(),
        axis.text.y  = element_blank(),
        axis.title.x = element_text(size=11, vjust=-10),
        axis.title.y = element_text(size=11, vjust=-10),
        plot.margin = unit(c(0, 1, 1, 1), "cm")) 
ggsave("figs/box_text_media.pdf", height=6)

