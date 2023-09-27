"
Purpose: Correspondence Analysis
Gaurav Sood and Philip Habel

Where?: In the Clouds
"

# set basedir
setwd(basedir)
setwd("media/uk_media_ideology/")

# Load libs 
library(ggplot2)
library(scales)
library(grid)
library(goji)

# Load data
load("tabs/first-stage-all-results.rdata")

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
jour <- read.csv("data/twitter/handles/unique_twitter_handles.csv", stringsAsFactors=F)
jour$screen_name2 <- tolower(jour$screen_name)
jourdf <- merge(df, jour, by="screen_name2", all.x=F, all.y=F)

jourdf_s <- subset(jourdf, publmedium %in% c("TELEGRAPH", "TIMES", "SUNDAY TELEGRAPH", "SUN", "INDEPENDENT", "FINANCIAL TIMES", "DAILY TELEGRAPH", "DAILY MAIL", "BBC NEWS")) 

jourdf_s$publmedium[jourdf_s$publmedium %in% c("TELEGRAPH", "DAILY TELEGRAPH", "SUNDAY TELEGRAPH")] <- "TELEGRAPH"

ggplot(jourdf_s, aes(x = factor(publmedium), fill = factor(publmedium), y = svd.phi)) +
  geom_dotplot(binaxis = "y", stackdir = "center",binwidth =.045, binpositions="all", alpha=.3, width=.5) + 
  theme_minimal() +
  labs(x="",y="") + 
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
ggsave(file="figs/media_dotplot.pdf")

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

# checking correlation
#cc <- merge(parl, df, by.x="twitter", by.y="screen_name")
#cor(cc$idealPoint, cc$svd.phi) ## 0.9435701
#cor(cc$idealPoint[cc$party=="D"], cc$svd.phi[cc$party=="D"]) # 0.7056044
#cor(cc$idealPoint[cc$party=="R"], cc$svd.phi[cc$party=="R"]) # 0.4351893
#plot(cc$idealPoint, cc$svd.phi)

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

ggsave(file="figs/parl_box.pdf")
