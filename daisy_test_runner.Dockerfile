# Copyright 2018 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
ARG PROJECT_ID=compute-image-tools-test
FROM gcr.io/$PROJECT_ID/wrapper:latest

FROM golang

WORKDIR /daisy
COPY . .
RUN cd daisy_test_runner && CGO_ENABLED=0 go build -o /daisy_test_runner
RUN chmod +x /daisy_test_runner

FROM alpine

RUN apk add --no-cache git bash
ENV GOOGLE_APPLICATION_CREDENTIALS /etc/compute-image-tools-test-service-account/creds.json

COPY --from=0 /wrapper wrapper
COPY --from=1 /daisy_test_runner daisy_test_runner
COPY daisy_test_runner/main.sh main.sh
ENTRYPOINT ["./wrapper", "./main.sh"]
