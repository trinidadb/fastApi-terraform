import uvicorn

def run():
 uvicorn.run("app.main:app", host="0.0.0.0", port=8000)

if __name__ == "__main__":
    run()