import smtplib
from email.mime.text import MIMEText
import pandas as pd

from constants.email_credentials import GMAIL_USER_AIR, GMAIL_PASSWORD_AIR


class EmailSender():
    GMAIL_PASSWORD = GMAIL_PASSWORD_AIR
    GMAIL_USER = GMAIL_USER_AIR

    def __init__(self):
        self.server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
        self.server.login(EmailSender.GMAIL_USER, EmailSender.GMAIL_PASSWORD)

    def end_connection(self):
        self.server.quit()

    def _build_email(self, to_email, subject, body):
        # Create a plain text message
        msg = MIMEText(body)
        msg['Subject'] = subject
        msg['From'] = EmailSender.GMAIL_USER
        msg['To'] = to_email

        return msg.as_string()

    def send_email(self, to_email, subject="Dummy subject", body= "Dummy body"):
        content = self._build_email(to_email, subject, body)
        try:
            # Connect to the Gmail SMTP server
            self.server.sendmail(EmailSender.GMAIL_USER, to_email, content)          
            print(f'Email sent to {to_email}')
        except Exception as e:
            print(f'Failed to send email to {to_email}: {str(e)}')

    def _get_employes_info(self, csv_path = "app/static/contacts.csv"):
        return pd.read_csv(csv_path)
    
    def send_reminder_to_all_employes(self):
        info = self._get_employes_info()
        body = 'Por favor recorda completar las horas en el excel: https://docs.google.com/spreadsheets/d/1le56L'
        subject = 'Recordatorio para completar horas'
        for _, row in info.iterrows():
            personalized_body = f'Hola {row['nombre']}! \n\n{body}'
            self.send_email(row['email'], subject, personalized_body)