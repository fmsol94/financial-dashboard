from livereload import Server

from financial_dashboard.app_factory import create_app

if __name__ == "__main__":
    app = create_app()

    server = Server(app.wsgi_app)

    server.watch("templates/**/*.html", delay=0.5)
    server.watch("templates/*.html", delay=0.5)

    server.watch("static/css/*.css", delay=0.5)
    server.watch("static/js/*.js", delay=0.5)

    server.serve(port=5500, host="127.0.0.1", debug=True)
