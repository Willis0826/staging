from dash import Dash, html
from flask import Flask

app = Dash(name=__name__)
server = app.server

def serve_layout():
    return html.Div(["Join the food revolution"])

app.layout = serve_layout