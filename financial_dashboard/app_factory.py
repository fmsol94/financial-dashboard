from pathlib import Path

from flask import Flask

from financial_dashboard.blueprints.accounts import acct_bp


def create_app():
    root = Path(__file__).resolve().parent.parent
    app = Flask(
        __name__,
        template_folder=str(root / "templates"),
        static_folder=str(root / "static"),
    )

    app.config.update(
        TEMPLATES_AUTO_RELOAD=True,
        SEND_FILE_MAX_AGE_DEFAULT=0,
        DATA_DIR=str(root.parent / "data"),
    )

    app.register_blueprint(acct_bp)

    return app
