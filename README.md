# Mercury website

Contents:

-   [Mercury website](#mercury-website)
-   [Editing the website](#editing-the-website)
-   [Hosting the website](#hosting-the-website)

# Editing the website

You will need:

-   Latest version of NodeJS installed
-   Latest version of npm installed
-   Latest version of Docker installed
-   A terminal
-   A modern web browser

Instructions:

-   Clone the repository to your local machine
-   Open a terminal and navigate to the directory of the repository
-   Run `npm i -g pnpm` to install pnpm
-   Run `pnpm i` to install all dependencies.

-   Copy the `.env.example` file to `.env` to set up the environment variables (if the containers are set up on localhost, likely nothing needs to be changed)
-   Run `docker-compose up -d` to start the Postgres and RedisGraph databases
-   Run `npx prisma migrate dev` to apply the schema to the Postgres database and create the PrismaClient package

-   Run `npx prisma studio` to open the database editor on port 5555
-   Navigate to the Regkey table and create a registration key, set key and usesLeft fields to whatever you want

To start a local dev server, run `npm run dev` and navigate to the link shown in the terminal (remember not to use HTTPS!). Upon saving a file, your changes will be shown in the web browser.

After starting a local web server, navigate to /register and make an account. Set the registration key to mercurkey-<your key\>.

To build for production, run `npm run build`, then `npm run preview` (or `npm run buildview`) to preview the final site.

# Hosting the website

You will need:

-   Everything above including pnpm
-   A TLS certificate, nginx reverse proxy with certbot works well

Instructions:

-   Clone the repository to your server, and navigate to its directory
-   Run `docker-compose up -d` to start the Postgres and RedisGraph databases
-   Copy the `.env.example` file to `.env` to set up the environment variables (if the containers are set up on localhost, likely nothing needs to be changed)
-   Run `npx prisma migrate deploy` to apply the schema to the Postgres database and create the PrismaClient package
-   Open a terminal and navigate to the directory of the repository
-   Run `npm i -g pm2` to install pm2, the node process manager
-   Run `./deploy.sh` to install dependencies, build, and start the website.

You can run other commands to manage the process, see `pm2 --help` for more information.
