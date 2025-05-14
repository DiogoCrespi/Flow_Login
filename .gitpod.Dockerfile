FROM gitpod/workspace-full

USER gitpod

# Instalar o Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable /home/gitpod/flutter
ENV PATH="/home/gitpod/flutter/bin:/home/gitpod/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Aceitar licenças e preparar o ambiente
RUN flutter doctor
RUN flutter config --enable-web
RUN flutter precache --web
