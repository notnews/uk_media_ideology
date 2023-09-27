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

# Read in data
media_sum <- read.csv("tabs/text/uk_media_clean_summarized_deduped_201x.csv")
small_media <- subset(media_sum, n_transcripts > 1000)

# Total Transcripts
sum(small_media$n_transcripts)

# Preparing for printing
small_media$src_name  <- toTitleCase(small_media$src_name)
small_media$from_date <- format(as.Date(small_media$from_date,format='%Y-%m-%d'),format='%Y-%m-%d')
small_media$to_date   <- format(as.Date(small_media$to_date,format='%Y-%m-%d'),format='%Y-%m-%d')

names(small_media) <- c("Name", "No. of Transcripts", "From", "To") 

print(
	  xtable(small_media, 
	  	caption="Summary of the Media Data", 
	  	align= c("p{0.1\\textwidth}",  "p{0.3\\textwidth}", "p{0.1\\textwidth}", "p{0.15\\textwidth}", "p{0.15\\textwidth}"), label="tab:summary"), 
		include.rownames = FALSE,
		floating=FALSE,
	    include.colnames = TRUE, size="\\tiny", 
	    tabular.environment = "longtable",
	    type = "latex", sanitize.text.function = function(x){x},
	    caption.placement="top",table.placement="!htb",
	    file="tabs/text/media_summary.tex")

# top 100 Lib/Con Predictors
top100_c <- read.csv("tabs/text/top10_cons_3c.csv")

col1 <- top100_c$term[1:34]
col2 <- top100_c$term[35:68]
col3 <- c(top100_c$term[69:100], "", "")

res <- data.frame(col1, col2, col3)
#names(res) <- rep(c("Bigrams and Trigrams"),3)
print(
	  xtable(res, 
	  	caption="Top 100 Predictors of Conservative Speech", 
	  	align= c("p{0.1\\textwidth}",  "p{0.3\\textwidth}", "p{0.3\\textwidth}", "p{0.3\\textwidth}"), label="tab:top_100c"), 
		include.rownames = FALSE,
		floating=FALSE,
	    include.colnames = FALSE, 
	    size="\\scriptsize", 
	    tabular.environment = "longtable",
	    type = "latex", sanitize.text.function = function(x){x},
	    caption.placement="top",
	    table.placement="!htb",
	    file="tabs/text/top100_c.tex")

top100_l <- read.csv("tabs/text/top10_lab_3c.csv")

col1 <- top100_l$term[1:34]
col2 <- top100_l$term[35:68]
col3 <- c(top100_l$term[69:100], "", "")

res <- data.frame(col1, col2, col3)
print(
	  xtable(res, 
	  	caption="Top 100 Predictors of Labour Speech", 
	  	align= c("p{0.1\\textwidth}",  "p{0.3\\textwidth}", "p{0.3\\textwidth}", "p{0.3\\textwidth}"), label="tab:top_100c"), 
		include.rownames = FALSE,
		floating=FALSE,
	    include.colnames = FALSE, 
	    size="\\scriptsize", 
	    tabular.environment = "longtable",
	    type = "latex", sanitize.text.function = function(x){x},
	    caption.placement="top",table.placement="!htb",
	    file="tabs/text/top100_l.tex")

# Test Data Cross-Tab
res <- data.frame(party=NA, precision =NA,    recall = NA,  f1score = NA,   support = NA)
res[1,] <- c("Conservative", "0.74", "0.74", "0.74", "1981")
res[2,] <- c("Labour", "0.74", "0.74", "0.74", "2019")

print(
	  xtable(res, 
	  	caption="Out-of-sample Performance of the model", 
	  	label="tab:text_validation"), 
		include.rownames = FALSE,
	    include.colnames = TRUE, 
	    caption.placement="top",
	    table.placement="!htb",
	    file="tabs/text/validation.tex")