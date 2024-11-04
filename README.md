
# Ubuntu Ruby Template

This repository provides a Docker template for setting up a Ruby environment on Ubuntu. It’s designed for testing or development purposes, with a built-in Ruby script (`test.rb`) that performs system resource checks and calculates prime numbers.

## Project Structure

- **Dockerfile**: Defines the Docker image configuration, installing Ruby, RVM, and essential libraries.
- **entrypoint.sh**: The entry point script that sets up the Ruby environment and executes the `test.rb` script.
- **test.rb**: A sample Ruby script to perform system diagnostics and count prime numbers.

## Getting Started

### Prerequisites

- [Docker](https://www.docker.com/get-started) installed on your machine.

### Build the Docker Image

To build the Docker image, navigate to the project directory and run:

```bash
docker build . -t ubuntu-ruby-template
```

This command creates a Docker image named `ubuntu-ruby-template` using the Dockerfile.

### Running the Container

There are two main options for running the container: interactively or with the default entrypoint.

#### Option 1: Interactive Mode

To start an interactive bash session within the container, use:

```bash
docker run -it ubuntu-ruby-template bash
```

This command allows you to explore the container’s environment, run commands, or modify files directly.

#### Option 2: Running with `entrypoint.sh`

To run the container with the default entrypoint, simply execute:

```bash
docker run ubuntu-ruby-template
```

This command will run `entrypoint.sh`, which initializes the Ruby environment and executes the `test.rb` script.

## Script Details

### The `entrypoint.sh` File

The `entrypoint.sh` script is a bash script that runs upon starting the container. It loads the Ruby environment (using RVM) and then executes `test.rb`.

```bash
#!/bin/bash
source /etc/profile.d/rvm.sh
ruby test.rb
```

### The `test.rb` Script

The `test.rb` script is a diagnostic Ruby script designed to give the system some processing work while reporting system resource statistics. It performs the following actions:

1. **System Stats**: Gathers and prints memory, CPU, and disk usage statistics.
2. **Prime Number Calculation**: Counts through prime numbers up to 100, displaying each prime number alongside current system stats.

```ruby
require 'prime'

def get_system_stats
  # Retrieves memory, CPU, and disk stats, compatible with macOS and Ubuntu.
end

def print_system_stats(stats)
  # Prints formatted system stats.
end

Prime.each(100) do |prime|
  stats = get_system_stats
  print_system_stats(stats)
  puts "Current Prime: #{prime}"
end
```

The script periodically outputs information like:

- Total, used, and free memory
- CPU usage percentage
- Disk space usage
- The current prime number in the sequence

This sample output can be helpful in testing containerized system performance or resource monitoring, but for us its just giving the template something to do.

## Dockerfile Breakdown

The Dockerfile defines an Ubuntu environment with Ruby installed via RVM, along with dependencies for Ruby development.

Key sections include:

- **Environment Setup**: Installs build tools, Ruby dependencies, and other libraries required for Ruby and PostgreSQL.
- **Ruby Installation**: Installs RVM and Ruby 3.2.2.
- **Entrypoint Setup**: Copies the `entrypoint.sh` file and sets it as executable.

Here’s a brief summary of the Dockerfile commands:

```dockerfile
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update &&     apt-get install -y     build-essential     curl     libpq-dev     postgresql-client     software-properties-common     tmux     libssl-dev     zlib1g-dev     libreadline-dev     libyaml-dev     libxml2-dev     libxslt1-dev     libcurl4-openssl-dev     libffi-dev

# Install RVM and Ruby
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - &&     curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - &&     curl -sSL https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm install ruby-3.2.2 --with-openssl-dir=$HOME/.rvm/usr"

WORKDIR /app

# Copy Gemfile and install dependencies
COPY Gemfile Gemfile.lock /app/
RUN /bin/bash -l -c "rvm use ruby-3.2.2 && gem install bundler && bundle install"

# Copy application files
COPY . /app

# Set entrypoint and permissions
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

CMD ["/app/entrypoint.sh"]
```

## Customization

You can modify `entrypoint.sh` to execute other scripts or customize `test.rb` to test different aspects of the system. Just update the script in the `/app` directory and rebuild the image.