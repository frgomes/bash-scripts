#!/bin/bash

function swagger_editor {
  docker pull swaggerapi/swagger-editor
  docker run -d -p ${PORT_SWAGGER}:8080 swaggerapi/swagger-editor
  chromium http://localhost:${PORT_SWAGGER}/ &
}
