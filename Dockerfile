# build phase
# get node container to build app
FROM centos/nodejs-12-centos7

# set metadata
LABEL Author="Angelo Chantziantoniou <angelo.chantziantoniou@gov.ab.ca>"

#ENV NGINX_VERSION=1.16

# Set labels used in OpenShift to describe the builder images
 LABEL io.k8s.description="Platform for building nodejs applications" \
 io.k8s.display-name="NodeJS 12" \
 io.openshift.expose-services="8080:http" \
 io.openshift.tags="builder,html,nodejs"

# copy source files
COPY ./.s2i/bin/ /usr/local/s2i

# Defines the location of the S2I
LABEL io.openshift.s2i.scripts-url=image:///usr/local/s2i

# Copy the S2I scripts from ./.s2i/bin/ to /usr/local/s2i when making the builder image
COPY ./.s2i/bin/ /usr/local/s2i

# Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:0 /opt/app-root && chmod -R ug+rwx /opt/app-root

# Set the default user for the image, the user itself was created in the base image
USER 1001

# Specify the ports the final image will expose
EXPOSE 8080

# Set the default CMD to print the usage of the image, if somebody does docker run
CMD /usr/local/s2i/usage