# Create the container:
podman create \
        --replace \
        --cap-add AUDIT_WRITE \
        --cap-add AUDIT_CONTROL \
        --name=debian-fileserver \
        --hostname=debian-fileserver \
        --mount=type=bind,source=/etc/localtime,destination=/etc/localtime \
        --mount=type=bind,source=/etc/default/locale,destination=/etc/default/locale \
        --publish=2222:22 \
        --publish=9090:9090 \
        --restart=unless-stopped \
        ghcr.io/hurenkam/debian-fileserver:bookworm

# Start the container:
podman container start debian-fileserver

