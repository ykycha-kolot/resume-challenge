import unittest
from unittest.mock import patch, MagicMock
import json
from lambda.api_lambda import lambda_handler

class TestLambdaHandler(unittest.TestCase):
    @patch("api_lambda.table")
    def test_get_visits(self, mock_table):
        mock_table.get_item.return_value = {"Item": {"count": 5}}
        event = {"routeKey": "GET /visits"}
        result = lambda_handler(event, None)
        self.assertEqual(result["statusCode"], 200)
        body = json.loads(result["body"])
        self.assertEqual(body, {"count": 5})

    @patch("api_lambda.table")
    def test_get_visits_no_count(self, mock_table):
        mock_table.get_item.return_value = {}
        event = {"routeKey": "GET /visits"}
        result = lambda_handler(event, None)
        self.assertEqual(result["statusCode"], 200)
        body = json.loads(result["body"])
        self.assertEqual(body, {"count": 0})

    @patch("api_lambda.table")
    def test_post_visits(self, mock_table):
        mock_table.update_item.return_value = {"Attributes": {"count": 6}}
        event = {"routeKey": "POST /visits"}
        result = lambda_handler(event, None)
        self.assertEqual(result["statusCode"], 200)
        body = json.loads(result["body"])
        self.assertEqual(body, {"count": 6})

    @patch("api_lambda.table")
    def test_unsupported_route(self, mock_table):
        event = {"routeKey": "DELETE /visits"}
        result = lambda_handler(event, None)
        self.assertEqual(result["statusCode"], 400)
        self.assertIn("Unsupported route", json.loads(result["body"]))

    @patch("api_lambda.table")
    def test_exception_handling(self, mock_table):
        mock_table.get_item.side_effect = Exception("DynamoDB error")
        event = {"routeKey": "GET /visits"}
        result = lambda_handler(event, None)
        self.assertEqual(result["statusCode"], 500)
        self.assertIn("DynamoDB error", json.loads(result["body"]))

if __name__ == "__main__":
    unittest.main()