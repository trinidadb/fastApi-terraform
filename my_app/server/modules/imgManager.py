import os
from fastapi import HTTPException
import json
from time import time
from server.constants import IMAGE_DIR, MeatType, CutView
from server.utils.dummy import dummy_cropper_jamon, dummy_cropper_lomo, dummy_model_jamon, dummy_model_lomo

class ImgManager:

    @staticmethod
    def get_crop(img_name_prefix, meat_type):

        match meat_type:
            case MeatType.lomo.value:
                front_img_name = f"{img_name_prefix}-{MeatType.lomo.value}-{CutView.front.value}.jpg"
                new_img_paths = dummy_cropper_lomo(front_img_name)
            case MeatType.jamon.value:
                top_img_name = f"{img_name_prefix}-{MeatType.jamon.value}-{CutView.top.value}.jpg"
                side_img_name = f"{img_name_prefix}-{MeatType.jamon.value}-{CutView.side.value}.jpg"
                new_img_paths = dummy_cropper_jamon(top_img_name, side_img_name)

        return new_img_paths

    @staticmethod
    def add_metadata(img_name: str, accepted: bool):
        image_path = os.path.join(IMAGE_DIR, img_name)

        if not os.path.isfile(image_path):
            raise HTTPException(status_code=404, detail=f"Imagen {image_path} no encontrada")

        metadata_file_name, _ = os.path.splitext(img_name) # removes extension
        metadata_file_path = os.path.join(IMAGE_DIR, f"{metadata_file_name}.json")

        try:
            with open(metadata_file_path, "w", encoding="utf-8") as f:
                json.dump({"accepted": accepted}, f)
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Error al escribir metadatos: {e}")
        
    @staticmethod
    def _check_if_accepted(img_name: str):
        base_name, _ = os.path.splitext(img_name)
        metadata_path = os.path.join(IMAGE_DIR, f"{base_name}.json")
        if not os.path.isfile(metadata_path):
            raise FileNotFoundError()
        try:
            with open(metadata_path, "r", encoding="utf-8") as f:
                metadata = json.load(f)
            return metadata.get("accepted") is True
        except Exception as e:
            raise ValueError(e)

    @staticmethod
    def get_predictions(img_name_prefix, meat_type):
        match meat_type:
            case MeatType.lomo.value:
                front_img_name = f"{img_name_prefix}-{MeatType.lomo.value}-{CutView.front.value}-cropped.jpg"
                
                if not ImgManager._check_if_accepted(front_img_name):
                    raise ValueError(f"La imagen '{front_img_name}' no ha sido aceptada.")
                
                predictions = dummy_model_lomo(front_img_name)
            case MeatType.jamon.value:
                top_img_name = f"{img_name_prefix}-{MeatType.jamon.value}-{CutView.top.value}-cropped.jpg"
                side_img_name = f"{img_name_prefix}-{MeatType.jamon.value}-{CutView.side.value}-cropped.jpg"

                for name in (top_img_name, side_img_name):
                    if not ImgManager._check_if_accepted(name):
                        raise ValueError(f"La imagen '{name}' no ha sido aceptada.")

                predictions = dummy_model_jamon(top_img_name, side_img_name)
        
        return predictions

    @staticmethod
    def delete_old_images(age_limit_seconds: int = 3600):
        now = time()
        deleted = 0

        for filename in os.listdir(IMAGE_DIR):
            filepath = os.path.join(IMAGE_DIR, filename)
            try:
                file_mtime = os.path.getmtime(filepath)
                if now - file_mtime > age_limit_seconds:
                    os.remove(filepath)
                    deleted += 1
            except Exception as e:
                print(f"No se pudo eliminar {filepath}: {e}")

        print(f"{deleted} imágenes eliminadas de '{IMAGE_DIR}'")

    # @staticmethod
    # def read_image(img_name: str):
    #     path = f"{IMAGE_DIR}{img_name}"
    #     try:
    #         with open(path, "rb") as f:
    #             data = f.read()
    #         print(f"Imagen {path} leída correctamente ({len(data)} bytes)")
    #         return data
    #     except FileNotFoundError:
    #         raise FileNotFoundError(f"Archivo {path} no encontrado.")
    #     except Exception as e:
    #         raise RuntimeError(f"Error al leer la imagen {path}: {e}")