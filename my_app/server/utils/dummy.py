from server.constants import IMAGE_DIR
import os


def copy_image_binary(src_name: str, dest_name: str) -> None:
    src_path = os.path.join(IMAGE_DIR,src_name)
    dest_path = os.path.join(IMAGE_DIR,dest_name)
    with open(src_path, "rb") as src, open(dest_path, "wb") as dst:
        dst.write(src.read())

def dummy_cropper_lomo(front_img_name):
    front_crop_img_name = f"{front_img_name.split('.')[0]}-cropped.{front_img_name.split('.')[1]}"
    copy_image_binary(front_img_name, front_crop_img_name)
    return front_crop_img_name

def dummy_cropper_jamon(top_img_name, side_img_name):
    top_crop_img_name = f"{top_img_name.split('.')[0]}-cropped.{top_img_name.split('.')[1]}"
    side_crop_img_name = f"{side_img_name.split('.')[0]}-cropped.{side_img_name.split('.')[1]}"

    copy_image_binary(top_img_name, top_crop_img_name)
    copy_image_binary(side_img_name, side_crop_img_name)

    return top_crop_img_name, side_crop_img_name


def dummy_model_lomo(front_img_name):
    return {'prediction_key_1': 'prediction_value_1', 'prediction_key_2': 'prediction_value_2', 'prediction_key_3': 'prediction_value_3'}

def dummy_model_jamon(top_img_name, side_img_name):
    return {'prediction_key_1': 'prediction_value_1', 'prediction_key_2': 'prediction_value_2', 'prediction_key_3': 'prediction_value_3', 'prediction_key_4': 'prediction_value_4'}