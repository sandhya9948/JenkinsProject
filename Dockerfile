FROM jenkins/jenkins:lts-jdk11

# Switch to root user to install dependencies
USER root

# Install dependencies, including Docker CLI and Git
RUN apt-get update && apt-get install -y \
    lsb-release \
    python3-pip \
    curl \
    git \
    gnupg2 \
    ca-certificates \
    apt-transport-https

# Add Docker's official GPG key
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | tee /usr/share/keyrings/docker-archive-keyring.asc

# Add Docker's repository for the correct version of Debian (ensure it works for your version)
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# Update apt-get and install Docker CLI
RUN apt-get update && apt-get install -y docker-ce-cli

# Switch to Jenkins user
USER jenkins

# Install Jenkins plugins (BlueOcean and Docker Workflow)
RUN jenkins-plugin-cli --plugins "blueocean:1.25.3 docker-workflow:1.28"

# Expose Jenkins port
EXPOSE 8080

# Start Jenkins when the container starts
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
