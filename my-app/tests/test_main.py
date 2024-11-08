from unittest import mock, TestCase
import pytest
from fastapi.testclient import TestClient


class TestGenericFunctionaliti(TestCase):

    @pytest.mark.asyncio
    @mock.patch("app.main.initialize", new_callable=mock.AsyncMock)
    @mock.patch("app.main.on_finish", new_callable=mock.AsyncMock)
    async def test_lifespan(self, mk_on_finish, mk_initialize):
        """ Test that `initialize` and `on_finish` are called correctly within the lifespan context manager. """
        from app.main import app   # It's imported iniside so the original "initialize" and "on_finish" aren't called/imported

        with TestClient(app) as client:
            response = client.get("/")
            self.assertEqual(response.status_code, 200)
            self.assertEqual(response.json(), {"Hello": "World"})

        mk_initialize.assert_awaited_once()
        mk_on_finish.assert_awaited_once()
