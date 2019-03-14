# Flyability Advisor

To bootstrap the database with some initial flying sites data after cloning the repo (and installing ruby, rvm, postgres, etc.):

```sh
bundle install
rake db:create; rake db:migrate; rake db:seed;
rake forecasts:nws:get_all
rake flyability:calculate_all
```
