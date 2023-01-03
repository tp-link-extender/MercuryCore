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
- Copy the `.env.example` file to `.env` and follow the instructions in the file to set up the environment variables (if the containers are set up on localhost, likely nothing needs to be changed)
- Run `npx prisma migrate dev` to apply the schema to the Postgres database and create the PrismaClient package
- After starting a local web server, navigate to /register and make an account (leave registration key blank).

You should now be able to access pages such as /home.
