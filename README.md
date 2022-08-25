# mlops

- The code to train the model and to save the trained weights is located at `src/main.ipynb`. Run it to save the weights at `flask_app/checkpoints/`. 
- The `flask_app/checkpoints` folder contains tokenizer, model architecture and the model weights.
- The training data is stored in `data`.
- The linting CI used is black and is located at `.github/workflows/black.yml`
- The code for flask is located at `flask_app` and nginx server at `nginx`.
- `flask` is used to serve the model and `gunicorn` is used as a wsgi server to serve multiple requests. On top of this `nginx` is used as a http server to also serve the static files.
- The `dockerfile` is used to dockerize the `flask_app` along with `.dockerignore` file.
- The `nginx` folder contains the dockerfile, resource configurations and server configurations.
- `docker-compose.yml` binds both the `flask_app`, `nginx` container.
- Run `run_docker.sh` to deploy the application.
