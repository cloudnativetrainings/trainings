# Dockerfile

## Write Dockerfile
In this step we shall create Dockerfile. 

Create a Dockerfile with following content in current directory.
```
`cat > Dockerfile << EOF
FROM ubuntu:18.04
RUN apt-get update && apt-get install apache2 -y && apt-get clean
CMD ["apache2ctl", "-DFOREGROUND"]
EOF`
```

Verify the file: `cat Dockerfile`

Above Dockerfile content describes a `Debian jessie` Docker image with Apache web server installed.

- `FROM` indicates the base image for our build
- Each `RUN` line will be executed by Docker during the build
- Our `RUN` commands must be non-interactive. (You can‘t provide input to Docker during the build.)
- In many cases, we will add the `-y` flag to `apt-get`.

## Build it !

We can build a docker image by executing `docker build -t webserver .`

The docker build command builds an image from a Dockerfile and a context. The 
build’s context is the files at a specified location PATH or URL. The PATH is a 
directory on your local filesystem. The URL is a Git repository location.

The Docker daemon runs the instructions in the Dockerfile one-by-one, committing 
the result of each instruction to a new image if necessary, before finally 
outputting the ID of your new image.

View the stored images on your host:

`docker images`

## Run an image

Now we have an image created from Dockerfile, we'll run it.

`docker run -d -p 8080:80 --name www webserver`

Verify the output with curl:

`curl localhost:8080`

## Build a webapp image

We need to create a `index.html` file in `html` directory with following content.

<pre class="file" data-filename="html/index.html" data-target="prepend">
&lt;!DOCTYPE html&gt;
&lt;html&gt;
  &lt;head&gt;
    &lt;title&gt;This is a title&lt;/title&gt;
  &lt;/head&gt;
  &lt;body&gt;
    &lt;p&gt;Hello world!&lt;/p&gt;
  &lt;/body&gt;
&lt;/html&gt;
</pre>

Enhance our existing Dockerfile with following content.

`cat > Dockerfile << EOF
FROM ubuntu:18.04
RUN apt-get update && apt-get install apache2 -y && apt-get clean
COPY html /var/www/html
CMD ["apache2ctl", "-DFOREGROUND"]
EOF`

Verify the Dockerfile: `cat Dockerfile`
Verify the html file: `cat html/index.html`

The `COPY` instruction copies new files or directories from <src> and adds them 
to the filesystem of the container at the path <dest>.

## Build and Run it Again 

`docker build -t webserver .`

`docker run -d -p 8090:80 --name www1 webserver`

Verify the updated output with curl:

`curl localhost:8090`

### Try it yourself

Change the following things:
* Web content should contain `Docker is awesome!`
* Dockerfile should an `ENTRYPOINT` with the default argument `-DFOREGROUND`

### Validate

```
docker run -it -p 80:80 -n my-web my-image

# interactive shell in the container
# verify hostname and envrionment is the id of the conainer
hostname
env
df

#check if apache is running
ps -aufx
```

***Open second terminal***

Verify if you get your HTML text `Docker is awesome!`:

`curl localhost:80`