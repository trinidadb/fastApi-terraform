from apscheduler.schedulers.background import BackgroundScheduler
import atexit
import os
from server.modules import ImgManager
from server.constants import IMAGE_DIR, DELETE_IMGS_AFTER_SECONDS

def add_cleaning_img_job():
    scheduler = BackgroundScheduler()
    scheduler.add_job(lambda: ImgManager.delete_old_images(DELETE_IMGS_AFTER_SECONDS), "interval", minutes=10)
    scheduler.start()
    print(f"Cleaning job set. Images older than {DELETE_IMGS_AFTER_SECONDS} seconds will be automatically deleted.")
    atexit.register(lambda: scheduler.shutdown())  # Detener al cerrar



async def initialize():
    os.makedirs(IMAGE_DIR, exist_ok=True)
    add_cleaning_img_job()
