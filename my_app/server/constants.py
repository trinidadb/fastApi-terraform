from enum import Enum

API_PREFIX = "/api"
ROUTE_PREFIX = "/v1"

IMAGE_DIR = "./images/"
DELETE_IMGS_AFTER_SECONDS = 3600

class MeatType(str, Enum):
    lomo = "L"
    jamon = "J"


class CutView(str, Enum):
    top = "top"
    side = "side"
    front = "front"

