from flask import Blueprint, render_template

acct_bp = Blueprint("ui", __name__)


@acct_bp.route("/")
def index():
    return render_template("index.html")
