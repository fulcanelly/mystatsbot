# Stats bot

This is a bot for keeping track of done things and analyzing spent time


## How to run

1. Edit [env variables](./.env)
  - add telegram bot token
  - set posgresql password
2. Add network
```
docker network create my-network`
```
git@github.com:fulcanelly/mystatsbot.git
3. Start bot
```
docker compose up --build
```


## [Bot datasheet](./bot/DATASHEET.md)


## Todo list (From high to low priority)
 - [ ] Setup state
 - [x] More control over activities (delete, edit)
 - [ ] Make data visualization better
   - [x] Pagination
   - [ ] Separate site for viewing data
 - [ ] State garbage collection
 - [ ] Add activity groups
 - [x] Timezone settings
 - [x] Persist state (via tg VM)
 - [ ] Localization
 - [ ] Add events planer
 - [ ] Add timers for activities (some tasks i.e. activities can take some fixed time)
