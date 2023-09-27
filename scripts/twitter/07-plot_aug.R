"
Purpose: Plot the Scores
Gaurav Sood and Philip Habel

Where?: Dropbox
"

# set basedir
setwd(basedir)
setwd("uk_media_ideology/")

# Load libs 
library(ggplot2)
library(scales)
library(grid)
library(goji)
library(RColorBrewer)


# Load data
load("tabs/twitter/first-stage-all-results_aug.rdata")

coords <- res$colcoord
dimnames(coords)[[1]] <- res$colnames

# first dimension
head(sort(coords[,1]),n=10)
tail(sort(coords[,1]),n=10)

# second dimension
head(sort(coords[,2]),n=10)
tail(sort(coords[,2]),n=10)
# third dimension
head(sort(coords[,3]),n=10)
tail(sort(coords[,3]),n=10)

#names <- c("GdnPolitics", "AndrewSparrow", "Lesreidpolitics", "tnewtondunn",
#  "DPJHodges", "timespolitics", "davidbyers26", "RBlackBT", "TimesNewsdesk")
#elites <- coords[res$colnames %in% names,]

#plot(elites[,1], elites[,2], type="n")
#text(elites[,1], elites[,2], labels=rownames(elites))

### IDEAL POINTS FOR MEDIA ACCOUNTS

## results data
df <- data.frame(screen_name = res$colnames,
    svd.phi = res$colcoord[,1], svd.phi2 = res$colcoord[,2],
    svd.phi3 = res$colcoord[,3],
    stringsAsFactors=F)
df <- df[!duplicated(df$screen_name),]
df$screen_name2 <- tolower(df$screen_name)

# Media handles
jour <- read.csv("data/twitter/handles/aug_media_handles.csv", stringsAsFactors=F)
jour$screen_name2 <- tolower(jour$Twitter.Handle)
jourdf <- merge(df, jour, by="screen_name2", all.x=F, all.y=F)

write.csv(jourdf, file="out/twitter/media_aug.csv", row.names=F)

"

Three graphs
1. Overall density
2. Main outlets on a line
3. Clustering within outlets

"

# Graph 1: Boxplot of Media Outlets
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Plot this
palette <- brewer.pal("Greys", n=6)

jourdf$constant <- 1

ggplot(jourdf, aes(factor(jourdf$constant), svd.phi)) +
  geom_boxplot(fill=palette[3], alpha=.25, color="#cccccc") +
  theme_minimal() + 
  scale_y_continuous("Ideology", limits=c(-8,2.5), breaks=seq(-8, 2.5, 1)) + 
  geom_point(x=1, y=2.2, colour="red") + 
  geom_point(x=1, y=-1.1, colour="blue") + 
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
        plot.margin = unit(c(0, 1, 1, 1), "cm")) +
  geom_segment(aes(x=1, xend=.9, y=2.2, yend=2.0), size=0.25) + 
  annotate("text", x=.88, y=2.0, label = "Median Conservative", hjust= .7, size=3) +
  geom_segment(aes(x=1, xend=.9, y=-1.1, yend=-1.2), size=0.25) + 
  annotate("text", x=.88, y=-1.2, label = "Median Labour", size=3)
ggsave("figs/boxplot_all_media_aug.pdf", height=6)

# Graph 2: Main Outlets on a line 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

jourdf_s <- subset(jourdf, Outlet %in% c("BBC News", 
											 "Guardian, The", 
											 "Economist, The", 
											 "Daily Mail, The", 
											 "Mirror, The (Daily Mirror and The Sunday Mirror and Scottish Daily Mirror)", 
											 "Sun, The", 
											 "Times, The",
											 "Daily Telegraph, The, The Sunday Telegraph and The Sunday Telegraph Scotland", 
											 "Financial Times, The", 
											 "Daily Express, The",
											 "Sky")) 

jourdf_s$Outlet <- car::recode(jourdf_s$Outlet, "'Guardian, The' = 'The Guardian'; 
												'Economist, The' = 'The Economist';
												'Daily Mail, The' = 'The Daily Mail'; 
											 	'Mirror, The (Daily Mirror and The Sunday Mirror and Scottish Daily Mirror)' = 'The Mirror'; 
											 	'Sun, The' = 'The Sun'; 
											 	'Times, The' = 'The Times';
											 	'Daily Telegraph, The, The Sunday Telegraph and The Sunday Telegraph Scotland' = 'The Daily Telegraph'; 
											 	'Financial Times, The' = 'The Financial Times'; 
											 	'Daily Express, The' =   'The Daily Express'")

# Let us do a line with annotated points
jourdf_ss <- subset(jourdf_s, screen_name %in% c('@BBCNews', '@guardian', '@DailyMailUK', '@DailyMirror', '@TheSun', '@thetimes', '@Telegraph', '@Daily_Express', '@SkyNews'))
jourdf_ss[10, c("Outlet", "svd.phi")] <- c( "Median Conservative", 2.2)
jourdf_ss[11, c("Outlet", "svd.phi")] <- c( "Median Labour", -1.2)

jourdf_ss$svd.phi <- as.numeric(jourdf_ss$svd.phi)
jourdf_ss$filter  <- c(rep(0,9), 1, 1)
jourdf_ss$Outlet  <- factor(jourdf_ss$Outlet, levels=jourdf_ss$Outlet[order(jourdf_ss$svd.phi)])

ggplot(jourdf_ss, aes(x=svd.phi, y=Outlet, col=filter)) +
geom_point() + 
scale_x_continuous("Ideology", limits=c(-2, 2.5)) +  
theme_minimal() + 
theme(panel.grid.major.x = element_line(colour = "#ececec", linetype = "dotted"),
      panel.grid.minor.x = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.minor.x = element_blank(),
      legend.position  = "none",
      legend.key       = element_blank(),
      axis.title.x = element_text(size=11, vjust=-10),
      axis.title.y = element_blank(),
      plot.margin = unit(c(0, 1, 1, 1), "cm"))
ggsave("figs/line_plot_aug.pdf", width=7)

# Graph 3: Diversity within Outlets
# ~~~~~~~~~~~~~~~~~~~~```

ggplot(jourdf_s, aes(x = factor(Outlet), fill = factor(Outlet), y = svd.phi)) +
  geom_dotplot(binaxis = "y", stackdir = "center", binwidth =.045, binpositions="all", alpha=.3, width=.5) + 
  theme_minimal() +
  labs(y="Ideology", x="") + 
  coord_flip() + 
 theme(panel.grid.major.x = element_line(colour = "#ececec", linetype = "dotted"),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        legend.position  = "none",
        legend.key       = element_blank(),
        axis.title.x = element_text(size=11, vjust=-10),
        axis.title.y = element_text(size=11, vjust=-10),
        plot.margin = unit(c(0, 1, 1, 1), "cm"))
ggsave(file="figs/media_dotplot_aug.pdf")

# parliamentary data
parl <- read.csv("data/twitter/handles/uk_mps.csv", stringsAsFactors=F)
names(parl) <- tolower(names(parl))

# Only members with twitter handles
parl <- subset(parl, screen_name!="")

# Merge 
df$type <- NA
df$type[tolower(df$screen_name) %in% tolower(parl$screen_name[parl$party=="Labour"])] <- "Labour"
df$type[tolower(df$screen_name) %in% tolower(parl$screen_name[parl$party=="Conservative"])] <- "Conservative"
df$type[tolower(df$screen_name) %in% tolower(parl$screen_name[parl$party=="SNP"])] <- "SNP"

# Basic Regressions and cors
with(df, summary(reg <- lm(svd.phi ~ type)))
cor(df$svd.phi, as.numeric(df$type=="Labour"), use="na.or.complete")

# Plot
df <- subset(df, !is.na(type) & type!='J')
parldf <- merge(df, parl, by="screen_name")
parldfs <- parldf[,-which(names(parldf) %in% c("svd.phi2", "svd.phi3", "screen_name2", "id", "id_str", "location", "description", "type", "url", "screen_name"))]
write.csv(parldfs, file="out/twitter/mp_ideo.csv", row.names=F)

ggplot(data = df, aes(factor(type), svd.phi)) + 
geom_boxplot() +
labs(x="",y="") + 
theme_minimal() +
theme(panel.grid.major.y = element_line(colour = "#e3e3e3", linetype = "dotted"),
	  panel.grid.minor.x = element_blank(),
	  panel.grid.major.x = element_line(colour = "#f1f1f1", linetype = "solid"),
	  panel.border       = element_blank(),
	  legend.position  = "none",
	  legend.key       = element_blank(),
	  legend.key.width = unit(1,"cm"),
 	  title        = element_text(size=8),
	  axis.title   = element_text(size=8),
	  axis.text    = element_text(size=8),
	  axis.ticks.y = element_blank(),
	  axis.ticks.x = element_line(colour = '#f1f1f1'),
	  strip.text.x =  element_text(size=9),
	  legend.text=element_text(size=8)) 

ggsave(file="figs/parl_box_aug.pdf")
