from fastapi import APIRouter, File, UploadFile, Path, Body
from fastapi.responses import FileResponse
import os
from typing import Optional
import uuid

from server.constants import IMAGE_DIR
from server.utils.validators import ImageMetaValidator, MeatType, CutView
from server.modules import ImgManager

router = APIRouter(tags=['imgManager'])


@router.post('/upload/{meat_type}/{cut_view}')
async def upload_init_img(meat_type: MeatType = Path(...),
                          cut_view: CutView = Path(...),
                          img: UploadFile = File(...),
                          img_prefix: Optional[str] = Body(default=None)):

    _ = ImageMetaValidator(meat_type=meat_type, cut_view=cut_view)

    prefix = img_prefix or str(uuid.uuid4())
    img.filename = f"{prefix}-{meat_type.value}-{cut_view.value}.jpg"
    contents = await img.read()

    with open(os.path.join(IMAGE_DIR, img.filename), "wb") as f: f.write(contents)

    return {"img_name_prefix": prefix}


@router.post('/preprocess/{meat_type}')
async def preprocess_init_img(imgs_name_prefix: str, meat_type: MeatType = Path(...)):
    new_images_names = ImgManager.get_crop(imgs_name_prefix, meat_type)
    return {"new_images_names": new_images_names}


@router.get('/download/')
async def download_intermidiate_img(img_name: str):
    return FileResponse(os.path.join(IMAGE_DIR, img_name))


@router.post('/accepted/')
async def get_img_acceptance_status(img_name: str, accepted: bool):
    _ = ImgManager.add_metadata(img_name, accepted)
    return {"msg": f"Cropped image was {"accepted" if accepted else "regected"}"}


@router.get('/getvalues/{meat_type}')
async def read_user_me(imgs_name_prefix: str, meat_type: MeatType = Path(...)):
    predictions = ImgManager.get_predictions(imgs_name_prefix, meat_type)
    return {"predictions": predictions}