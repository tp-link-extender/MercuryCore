# Mercury website

## To begin editing the website, you will need

- Latest version of NodeJS installed
- Latest version of npm installed
- A terminal
- A modern web browser

Instructions:

- Clone the repository to your local machine
- Open a terminal and navigate to the directory of the repository
- Run `npm i -g pnpm` to install pnpm
- Run `pnpm i` to install all dependencies.
  
To start a local dev server, run `npm run dev` and navigate to the link shown in the terminal (remember to use HTTPS!). Upon saving a file, your changes will be shown in the web browser.

To build for production, run `npm run build`, then `npm run preview` (or `npm run buildview`) to preview the final site.

## To edit further parts of the website, such as the homepage, you will need

- Latest version of Docker installed

Instructions:

- Run `docker-compose up -d` to start the Postgres and RedisGraph databases
- Copy the `.env.example` file to `.env` to set up the environment variables (if the containers are set up on localhost, likely nothing needs to be changed)
- Run `npx prisma migrate dev` to apply the schema to the Postgres database and create the PrismaClient package
- After starting a local web server, navigate to /register and make an account (leave registration key blank).

You should now be able to access pages such as /home.

## To host the website and databases, you will need

- Everything above including pnpm
- A TLS certificate, nginx reverse proxy with certbot works well

Instructions:

- Clone the repository to your server, and navigate to its directory
- Run `docker-compose up -d` to start the Postgres and RedisGraph databases
- Copy the `.env.example` file to `.env` to set up the environment variables (if the containers are set up on localhost, likely nothing needs to be changed)
- Run `npx prisma migrate deploy` to apply the schema to the Postgres database and create the PrismaClient package
- Open a terminal and navigate to the directory of the repository
- Run `npm i -g pm2` to install pm2, the node process manager
- Run `./deploy.sh` to install dependencies, build, and start the website.

You can run other commands to manage the process, see `pm2 --help` for more information.
We've identified a current issue with the friends/followers network in RedisGraph. If you try to follow an account and their follower count doesn't immediately update, try removing the /data/redis folder (will only clear friends/followers network) or restarting its docker container before trying again.
