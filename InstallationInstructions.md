These are instructions to install the server side parts
# Installation Instructions #

## Introduction ##

For this project to work you will need
  * Windows (preferably 7)
  * Internet Information Server (included in any Win7 install)
  * MS SQL Server 2008 (free download)

## Windows ##
We have installed all software on a Windows 7 virtual machine (Win7 Ultimate), but even at home with Windows 7 Home Premium all software can run fine.

## Internet Information Server ##
  * Go to Control panel
  * Go to Software and features
  * Go to Turn Windows Features on or off
  * Enable Internet Information Server. Make sure ASP is also selected
  * Restart PC

## MS SQL Server 2008 (optional, if you use MS Access) ##
  * Download [SQL server 2008](http://www.microsoft.com/download/en/details.aspx?id=20302)
  * Download [SQL Server management studio](http://www.microsoft.com/download/en/details.aspx?id=7593)
  * install both
  * If you like you can try SQL Server 2012 but I haven't tried it yet [sql server 2012](http://www.microsoft.com/betaexperience/pd/SQLEXPCTAV2/enus/default.aspx)
  * restart PC

# Setup the application #

## setup the website ##
  * This website uses plain old ASP, so you don't need any ASP.NET features. You can safely switch those off if you like.
  * Open IIS
  * Click Sites
  * Click 'add website...'
  * Give it a name and click 'OK'
  * add a line to \windows\system32\drivers\etc\hosts as follows
    * 127.0.0.1 quizbaker
  * You can use the default application pool, as long as this is set to 'no managed code'
  * Authentication should be set to Windows Authentication. For this feature you will need to have at least Windows 7 Professional. For Home versions, you can use Anonymous Authentication. That last option does mean students need to enter their name, instead of having it automatically recorded. If you have a domain, you should have Windows 7 Pro or higher.
  * select an application pool
  * in the application pool, set 'no managed code', and 'enable 32 bit applications' (that is for the 32 bit database driver)
  * download all code from the google code project and copy it under the site.
  * go into the file /DB/config.asp and check the settings
  * set write permissions to the website folder for the anonymous IUSR account and/or the domain users
  * test the site: go to http://quizbaker

## create the MSSQL database ##
  * Open SQL server management studio
  * Select the database server
  * download the sql script to create the database
  * run the script in a new query window

## alternative: MS Access version ##
  * in /db/config.asp set dbtype to MS Access
  * open quizbaker.mdb
  * modify vwSummary and vwDetails and replace DOMAIN with your own domain name
  * install the [MS Access driver](http://www.microsoft.com/download/en/details.aspx?id=13255)
  * make sure the mdb file is not read-only

## test a quiz ##
  * create a quiz using [Articulate Quizmaker](http://www.articulate.com/)
  * publish in WEB format
  * copy all files of this quiz to a folder under your site (e.g. a folder named 'quiz')
  * overwrite the quiz.html with the one in the source. You can also download the networking quiz zip file to test.
  * test the quiz http://quizbaker/quiz/quiz.html