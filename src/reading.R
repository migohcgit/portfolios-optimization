# Reads every CSV file in data/ that contains Date y Price.
# Every file represents an asset; file name is its ticker/name.
files <- list.files(DATA_DIR, pattern = "\\.csv$", full.names = TRUE, ignore.case = TRUE)
if (length(files) < 2) stop("Include at least two CSV assets files in data/.")

read_asset <- function(path) {
  raw <- read.csv(path, stringsAsFactors = FALSE, check.names = FALSE, fileEncoding = "UTF-8-BOM")
  names(raw) <- trimws(names(raw))
  if (!all(c("Date", "Price") %in% names(raw))) {
    stop(sprintf("%s file must include Date y Price named columns", basename(path)))
  }
  # Example data uses mm/dd/yyyy date type. Price must be a number
  date <- as.Date(raw$Date, format = "%m/%d/%Y")
  price <- suppressWarnings(as.numeric(gsub(",", "", raw$Price, fixed = TRUE)))
  valid <- !is.na(date) & is.finite(price) & price > 0
  out <- data.frame(Date = date[valid], Price = price[valid])
  out <- out[order(out$Date), ]
  out <- out[!duplicated(out$Date, fromLast = TRUE), ]
  if (nrow(out) < 3) stop(sprintf("%s not contains enough valid observations.", basename(path)))
  names(out)[2] <- tools::file_path_sans_ext(basename(path))
  out
}

assets <- lapply(files, read_asset)
names(assets) <- vapply(files, function(x) tools::file_path_sans_ext(basename(x)), character(1))

# this part aligns by date and ensures no merge non coincidence dates in the rows
prices <- Reduce(function(x, y) merge(x, y, by = "Date", all = FALSE), assets)
prices <- prices[order(prices$Date), ]
asset_names <- setdiff(names(prices), "Date")
if (nrow(prices) < 3) stop("Assets don't have enough common dates")