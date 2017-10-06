require(reshape2)
require(dplyr)

#load state from datasets
data(state)

#country level data
us_lvl <- data.frame(state.region,state.division,state.name)

#state level data (melted to long data.frame)
state_lvl <- state.x77%>%
  data.frame%>%
  mutate(state.name=row.names(.))%>%
  melt(.,'state.name')

#nest state level in country level
states <- us_lvl%>%left_join(state_lvl,by='state.name')