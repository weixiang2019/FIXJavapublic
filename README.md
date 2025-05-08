# Introduction 
FIX Application for communicating trades from us to Broadridge and receiving acknowledgements from Broadridge Gems.

# Getting Started

## Database prerequisites
This application uses Windows authentication. For it to interface with the database successfully, the service ID it uses has to be given read, write, and execute privileges on the following databases:
1. TradeLoadstaging
2. TradeLoadConfig

To install this application onto a server:
1. Install the needed dependencies onto the intended server (JDK 21 and Maven 3.9.9).
2. Clone the repo and build the program using Maven (refer to Build and Test section for instruction). This step will require internet connection, not only for cloning the repo, but also for building the application.
3. Copy the JAR file after building onto server.

To Launch the application, use `java -jar <path_to_program_jar>`.

# Build and Test
Building the program requires JDK 21 and Maven 3.9.9 as well as internet connection for grabbing the necessary dependencies from the Maven Central repo.

Make sure https://repo.maven.apache.org/ is whitelisted. If the device the program is being built on uses internet control tool that swaps source SSL certificates, the new certificate may need to be added to the trust store of the installed JDK.

Once the above steps are done, navigate to the directory of the project using a terminal and build the project using `mvn package`. The finished JAR should be located in the `target` folder.

Currently, testing is done by simple running the finished build on the UAT environment.
