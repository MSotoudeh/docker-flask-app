from app import create_app

def test_root_endpoint():
    app = create_app()
    client = app.test_client()

    response = client.get("/")
    assert response.status_code == 200
    assert "Hello from Dockerized Flask App!" in response.data.decode()
