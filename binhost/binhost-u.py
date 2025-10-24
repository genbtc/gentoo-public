# @ copyleft genr8eofl @ gentoo IRC Jan 26 2023 - 2025

from fastapi import FastAPI, Form
from typing import Union
import mimetypes
mimetypes.init()

app = FastAPI()

#SHOW ENDPOINTS (try to keep updated manually.)
@app.get("/")
def show_endpoints():
    return {"http://127.0.0.1:8448/hello": "GET - Hello World!",
            "http://127.0.0.1:8448/equery/g/{atom}": "GET - Gentoo query package dependencies",
            "http://127.0.0.1:8448/equery/u/{atom}": "GET - Gentoo query package USE Flags",
            "http://127.0.0.1:8448/binhost/u/{atom}": "GET - Gentoo query BINHOST USE Flags",
    }

#Hello World!: url = http://127.0.0.1:8448/hello
@app.get("/hello")
def read_root():
    return {"Hello": "World!"}

#Path Parameters dummy example, can turn into search (info@ https://fastapi.tiangolo.com/tutorial/path-params/)
@app.get("/items/{item_id}")
def read_item(item_id: int, q: str|None = None):
    return {"item_id": item_id, "q": q}

from mediawiki import MediaWiki

wikigentoo = MediaWiki(url='http://wiki.gentoo.org/api.php')


# EQUERY G - Use gentoo's equery to return a list of dependency_Graph for a package
@app.get("/equery/g/{atom}")
async def equery_g(atom: str):
    print("equery g "+atom)
    result = subprocess.run(
        ["equery","depgraph","-U",atom], capture_output=True, text=True
    )
    resultstr = result.stdout[:100000]    #cap to ~100KB
    return HTMLResponse(defaultstatichtmlpage+resultstr+htmlend, media_type='text/html')


#Show how to use the jinja templating system
from fastapi import Request
from fastapi.templating import Jinja2Templates

templates = Jinja2Templates(directory="templates")

# EQUERY U - Use gentoo's equery to return a list of USE Flags for a package
@app.get("/equery/u/{atom}")
async def equery_u(request: Request, atom: str, response_class=HTMLResponse):
    print("equery u "+atom)
    result = subprocess.run(
        ["equery","uses","-i",atom], capture_output=True, text=True
    )
    resultstr = result.stdout[:100000]	#cap to ~100KB
    return templates.TemplateResponse("layout.html", {"request": request, "pre": resultstr})

# BINHOST U - Use gentoo binhost to return a list of USE Flags from Packages file
app.get("/binhost/u/{atom}")
async def binhost_u(request: Request, atom: str, response_class=HTMLResponse):
    print("binhost u "+atom)
    result = subprocess.run(
        [""], capture_output=True, text=True
    )
    resultstr = result.stdout[:100000]	#cap to ~100KB
    return templates.TemplateResponse("layout.html", {"request": request, "pre": resultstr})


#probably best to start using a main function
def main(prog_name, *argv):
	print("Standalone Mode Not Implemented. Launch with uvicorn to run.")

if __name__ == '__main__':
    sys.exit(main(*sys.argv))
