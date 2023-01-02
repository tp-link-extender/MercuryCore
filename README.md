# Mercury website

## To begin editing the website, you will need

- Latest version of NodeJS installed
- Latest version of npm installed
- A terminal
- A modern web browser

Instructions:

- Clone the repository to your local machine
- Open a terminal and navigate to the directory of the repository
- Run `npm i -g pnpm` to install pnpm.
- Run `pnpm i` to install all dependencies.
  
To start a local dev server, run `pnpm run dev` and navigate to the link shown in the terminal (remember to use HTTPS!). Upon saving a file, your changes will be shown in the web browser.

To build for production, run `pnpm run build`, then `pnpm run preview` (or `pnpm run buildview`) to preview the final site.

## To edit further parts of the website, such as the homepage, you will need

- A running PostgreSQL database, version 15.1 or later (though prisma supports any version down to 9.6, these will likely work fine too)

Instructions:

- Create a `.env` file in the root directory of the repository
- Put the following content in the file: `DATABASE_URL="postgresql://postgres:<password>@localhost:<port>/main?schema=public"`
- Replace `<password>` with the password of your database, and replace `<port>` with its port number (replace `localhost` with the domain name or IP address of the server if it isn't hosted locally)
- Run `pnpm exec prisma migrate dev` to apply the schema to your database and create the PrismaClient package
- After starting a local web server, navigate to /register and make an account (leave registration key blank)

You should now be able to access pages such as /home.
