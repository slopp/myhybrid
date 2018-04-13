googlemaps <- import('googlemaps')

get_route <- function(start, end) {
  
  gmaps <- googlemaps$Client(key = Sys.getenv('DIRECTIONS_API'))
  
  route <- gmaps$directions(start,
                                  end,
                                  mode = "driving", 
                                  departure_time  = Sys.time())
  return(route)
  
}