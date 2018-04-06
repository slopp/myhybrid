source_python('./py-fastsim-2018a/src/FASTSim.py')

call_fastsim <- function(cycle, veh_id) {
  veh <- get_veh(veh_id)
  results <- sim_drive(cycle, veh)
  clean_results <- list(
    name = veh$name,
    sticker_mpg = veh$valCombMpgge,
    mpgge = results$mpgge,
    cum_gal = cumsum(results$fsKwhOutAch) / 32.78,
    mph_actual = results$mpsAch * 2.23694,
    gas_used = sum(results$fsKwhOutAch) / 32.78
  )
  clean_results
}


vehicle_list <- function(){
  vehs <- read.csv('py-fastsim-2018a/docs/FASTSim_py_veh_db.csv', stringsAsFactors = FALSE)
  vehs <- vehs[1:26,]
  tibble(
    id = vehs$Selection,
    name = vehs$Scenario.name, 
    type = vehs$vehPtType
  )
}

map_name_id <- function(name) {
  vehicles <- vehicle_list()
  vehicles$id[vehicles$name == name] 
}



simulate_vehicles <- function(cycle, id1, id2) {
  list(
    call_fastsim(cycle, id1),
    call_fastsim(cycle, id2)
  )
}

plot_cycle <- function(cycle) {
  ggplot(cycle) + 
    geom_line(aes(cycSecs, cycMph), size = 1.5) +
    scale_x_continuous(labels = function(b){round(b/60)}) +
    theme_minimal() +
    theme(text = element_text(size = 16)) +
    labs(
      x = 'Trip Duration (Mins)',
      y = 'MPH'
    )
}

plot_gas <- function(sim_results) {
  id1 <- tibble(
    gas = sim_results[[1]]$cum_gal,
    label = sim_results[[1]]$name,
    sec = 1:length(gas)
  )
  
  id2 <- tibble(
    gas = sim_results[[2]]$cum_gal,
    label = sim_results[[2]]$name,
    sec = 1:length(gas)
  )
  
  all <- rbind(id1, id2)
  
  ggplot(all) + 
    geom_line(aes(sec, gas, color = label), size = 1.5) +
    theme_minimal() +
    theme(text = element_text(size = 16)) +
    scale_color_fivethirtyeight() +
    scale_x_continuous(breaks = NULL) +
    theme(legend.position = 'bottom') +
    labs(
      color = NULL,
      y = 'Gallons of Gas Used',
      x = NULL
    )
}
