create_cycle <- function(route, smooth) {

    steps <- parse_route(route)
    steps <- add_stops(steps)
    cyc <- expand_steps_to_cycle(steps)
    cyc <- smooth_cycle(cyc, smooth)
    cyc$cycMph <- cyc$cycMps * 2.23694
    cyc
}


parse_route <- function(route) {
  tibble(
    distance_m = map_dbl(route[[1]]$legs[[1]]$steps, ~.x$distance$value),
    time_s = map_dbl(route[[1]]$legs[[1]]$steps, ~.x$duration$value),
    instruction = map_chr(route[[1]]$legs[[1]]$steps, ~.x$html_instructions),
    is_turn = str_detect(instruction, 'Turn'),
    mps = distance_m / time_s
  )
}

add_stops <- function(steps) {
  # First, add idle time at beginning of trip
  new_steps <- list()
  new_steps[[1]] <- list(
    mps = 0,
    time_s = 60
  )
  
  # Second, copy steps. If the next step is a "Turn", 
  # Add an intermediary stop for n seconds, 
  # where n ~ normal(20, 10)
  step <- 2
  for (i in 1:(nrow(steps) - 1)) {
    new_steps[[step]] <- list(
      mps = steps$mps[i],
      time_s = steps$time_s[i]
    )
    step <- step + 1
    if (steps$is_turn[i + 1]) {
      new_steps[[step]] <- list(
        mps = 0,
        time_s = max(0, round(rnorm(1, 20, 10)))
      )
      step <- step + 1
    }
  }
  
  #Add the last step, and a final stop at the end 
  new_steps[[step]] <- list(
    mps = steps$mps[nrow(steps)],
    time_s = steps$time_s[nrow(steps)]
  )
  
  new_steps[[step + 1]] <- list(
    mps = 0,
    time_s = 60
  )
  
  new_steps <- as.data.frame(do.call(rbind, new_steps))
  new_steps$mps <- unlist(new_steps$mps)
  new_steps$time_s <- unlist(new_steps$time_s)
  new_steps
}

expand_steps_to_cycle <- function(steps) {
  cyc <- tibble(
    cycMps = rep(steps$mps, steps$time_s),
    cycSecs = 1:length(cycMps)
  )
  cyc$cycGrade <- 0
  cyc$cycRoadType <- 0
  cyc
}

smooth_cycle <- function(cyc, smooth) {
  cyc$cycMps <- SMA(cyc$cycMps, smooth)
  cyc$cycMps[which(is.na(cyc$cycMps))] <- 0
  cyc
}


  
  