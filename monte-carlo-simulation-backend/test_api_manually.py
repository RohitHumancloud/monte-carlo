"""
Simple API Testing Script
Run this to manually test your Monte Carlo API endpoints

Prerequisites:
- Application must be running (uvicorn app.main:app --reload)
- pip install requests

Usage:
    python test_api_manually.py
"""

import requests
import json
from datetime import datetime

# Configuration
BASE_URL = "http://localhost:8000"
TEST_USER = {
    "email": f"test_{datetime.now().strftime('%Y%m%d%H%M%S')}@example.com",
    "password": "SecurePass123",
    "full_name": "Test User",
    "company": "Test Corp"
}

# Colors for terminal output
class Colors:
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    BOLD = '\033[1m'
    END = '\033[0m'

def print_success(message):
    print(f"{Colors.GREEN}✓{Colors.END} {message}")

def print_error(message):
    print(f"{Colors.RED}✗{Colors.END} {message}")

def print_info(message):
    print(f"{Colors.BLUE}ℹ{Colors.END} {message}")

def print_section(title):
    print(f"\n{Colors.BOLD}{Colors.YELLOW}{'='*60}{Colors.END}")
    print(f"{Colors.BOLD}{Colors.YELLOW}{title}{Colors.END}")
    print(f"{Colors.BOLD}{Colors.YELLOW}{'='*60}{Colors.END}\n")

def test_health_check():
    """Test health check endpoint"""
    print_section("TEST 1: Health Check")

    try:
        response = requests.get(f"{BASE_URL}/health")

        if response.status_code == 200:
            print_success(f"Health check passed! Status: {response.json()['status']}")
            print_info(f"Response: {json.dumps(response.json(), indent=2)}")
            return True
        else:
            print_error(f"Health check failed! Status code: {response.status_code}")
            return False
    except requests.exceptions.ConnectionError:
        print_error("Cannot connect to API! Make sure the server is running.")
        print_info("Run: uvicorn app.main:app --reload")
        return False
    except Exception as e:
        print_error(f"Error: {str(e)}")
        return False

def test_user_registration():
    """Test user registration"""
    print_section("TEST 2: User Registration")

    try:
        response = requests.post(
            f"{BASE_URL}/auth/register",
            json=TEST_USER
        )

        if response.status_code == 201:
            user_data = response.json()
            print_success(f"User registered successfully!")
            print_info(f"User ID: {user_data['id']}")
            print_info(f"Email: {user_data['email']}")
            print_info(f"Status: {user_data['status']}")
            return True, user_data
        else:
            print_error(f"Registration failed! Status: {response.status_code}")
            print_error(f"Error: {response.json()}")
            return False, None
    except Exception as e:
        print_error(f"Error: {str(e)}")
        return False, None

def test_user_login():
    """Test user login"""
    print_section("TEST 3: User Login")

    try:
        response = requests.post(
            f"{BASE_URL}/auth/login",
            json={
                "email": TEST_USER["email"],
                "password": TEST_USER["password"]
            }
        )

        if response.status_code == 200:
            token_data = response.json()
            access_token = token_data["access_token"]
            print_success(f"Login successful!")
            print_info(f"Token type: {token_data['token_type']}")
            print_info(f"Access token (first 50 chars): {access_token[:50]}...")
            return True, access_token
        else:
            print_error(f"Login failed! Status: {response.status_code}")
            print_error(f"Error: {response.json()}")
            return False, None
    except Exception as e:
        print_error(f"Error: {str(e)}")
        return False, None

def test_get_current_user(token):
    """Test protected endpoint"""
    print_section("TEST 4: Get Current User (Protected Endpoint)")

    try:
        headers = {"Authorization": f"Bearer {token}"}
        response = requests.get(f"{BASE_URL}/auth/me", headers=headers)

        if response.status_code == 200:
            user_data = response.json()
            print_success(f"Successfully accessed protected endpoint!")
            print_info(f"User: {user_data['email']}")
            print_info(f"Full name: {user_data.get('full_name', 'N/A')}")
            return True
        else:
            print_error(f"Failed to access protected endpoint! Status: {response.status_code}")
            return False
    except Exception as e:
        print_error(f"Error: {str(e)}")
        return False

def test_generate_api_key(token):
    """Test API key generation"""
    print_section("TEST 5: Generate API Key")

    try:
        headers = {"Authorization": f"Bearer {token}"}
        response = requests.post(
            f"{BASE_URL}/api-keys/generate",
            headers=headers,
            json={"name": "Test API Key"}
        )

        if response.status_code == 201:
            key_data = response.json()
            api_key = key_data["key"]
            print_success(f"API key generated successfully!")
            print_info(f"Key ID: {key_data['id']}")
            print_info(f"API Key: {api_key}")
            print_info(f"Expires in: {key_data['days_until_expiry']} days")
            return True, api_key
        else:
            print_error(f"API key generation failed! Status: {response.status_code}")
            print_error(f"Error: {response.json()}")
            return False, None
    except Exception as e:
        print_error(f"Error: {str(e)}")
        return False, None

def test_list_api_keys(token):
    """Test listing API keys"""
    print_section("TEST 6: List API Keys")

    try:
        headers = {"Authorization": f"Bearer {token}"}
        response = requests.get(f"{BASE_URL}/api-keys/list", headers=headers)

        if response.status_code == 200:
            keys = response.json()
            print_success(f"Successfully retrieved API keys!")
            print_info(f"Total keys: {len(keys)}")
            for key in keys:
                print_info(f"  - {key['name']}: {key['key_preview']} (Status: {key['status']})")
            return True
        else:
            print_error(f"Failed to list API keys! Status: {response.status_code}")
            return False
    except Exception as e:
        print_error(f"Error: {str(e)}")
        return False

def test_monte_carlo_simulation(api_key):
    """Test Monte Carlo simulation"""
    print_section("TEST 7: Monte Carlo Simulation")

    simulation_request = {
        "portfolio": {
            "assets": [
                {
                    "ticker": "NSEI Index",
                    "weight": 0.6,
                    "asset_class": "equity"
                },
                {
                    "ticker": "GIND10YR Index",
                    "weight": 0.4,
                    "asset_class": "bonds"
                }
            ]
        },
        "parameters": {
            "initial_investment": 1000000,
            "monthly_contribution": 50000,
            "time_horizon_years": 10,
            "num_simulations": 5000  # Reduced for faster testing
        }
    }

    try:
        headers = {"X-API-Key": api_key}
        print_info("Running simulation with 5,000 paths...")
        print_info("This may take 2-3 seconds...")

        response = requests.post(
            f"{BASE_URL}/api/v1/simulate",
            headers=headers,
            json=simulation_request
        )

        if response.status_code == 200:
            result = response.json()
            print_success(f"Simulation completed successfully!")
            print_info(f"Simulation ID: {result['simulation_id']}")
            print_info(f"Execution time: {result['execution_time_seconds']:.2f} seconds")
            print_info(f"Status: {result['status']}")

            # Display key results
            print_info("\n📊 Simulation Results:")
            final_value = result['results']['final_portfolio_value']
            print_info(f"  Mean final value: ₹{final_value['mean']:,.0f}")
            print_info(f"  Median final value: ₹{final_value['median']:,.0f}")
            print_info(f"  Min/Max: ₹{final_value['min']:,.0f} / ₹{final_value['max']:,.0f}")

            risk_metrics = result['results']['risk_metrics']
            print_info(f"\n📉 Risk Metrics:")
            print_info(f"  VaR (95%): ₹{risk_metrics['var_95']:,.0f}")
            print_info(f"  CVaR (95%): ₹{risk_metrics['cvar_95']:,.0f}")
            print_info(f"  Sharpe Ratio: {risk_metrics['sharpe_ratio']:.2f}")

            probs = result['results']['probabilities']
            print_info(f"\n📈 Probabilities:")
            print_info(f"  Probability of loss: {probs['probability_of_loss']:.1%}")
            print_info(f"  Probability of positive return: {probs['probability_of_positive_return']:.1%}")
            print_info(f"  Probability of doubling: {probs['probability_of_doubling']:.1%}")

            return True
        else:
            print_error(f"Simulation failed! Status: {response.status_code}")
            print_error(f"Error: {response.json()}")
            return False
    except Exception as e:
        print_error(f"Error: {str(e)}")
        return False

def run_all_tests():
    """Run all API tests"""
    print(f"\n{Colors.BOLD}{Colors.BLUE}")
    print("╔═══════════════════════════════════════════════════════════════╗")
    print("║       Monte Carlo API - Manual Testing Script                ║")
    print("║       Testing all endpoints...                                ║")
    print("╚═══════════════════════════════════════════════════════════════╝")
    print(f"{Colors.END}\n")

    results = []

    # Test 1: Health Check
    if not test_health_check():
        print_error("\n❌ Health check failed! Make sure the server is running.")
        print_info("Start server with: uvicorn app.main:app --reload")
        return
    results.append(("Health Check", True))

    # Test 2: User Registration
    success, user_data = test_user_registration()
    results.append(("User Registration", success))
    if not success:
        return

    # Test 3: User Login
    success, token = test_user_login()
    results.append(("User Login", success))
    if not success:
        return

    # Test 4: Get Current User
    success = test_get_current_user(token)
    results.append(("Get Current User", success))

    # Test 5: Generate API Key
    success, api_key = test_generate_api_key(token)
    results.append(("Generate API Key", success))
    if not success:
        return

    # Test 6: List API Keys
    success = test_list_api_keys(token)
    results.append(("List API Keys", success))

    # Test 7: Monte Carlo Simulation
    success = test_monte_carlo_simulation(api_key)
    results.append(("Monte Carlo Simulation", success))

    # Summary
    print_section("TEST SUMMARY")
    passed = sum(1 for _, result in results if result)
    total = len(results)

    for test_name, result in results:
        if result:
            print_success(f"{test_name}")
        else:
            print_error(f"{test_name}")

    print(f"\n{Colors.BOLD}Results: {passed}/{total} tests passed{Colors.END}")

    if passed == total:
        print(f"\n{Colors.GREEN}{Colors.BOLD}🎉 All tests passed! Your API is working perfectly!{Colors.END}\n")
    else:
        print(f"\n{Colors.YELLOW}{Colors.BOLD}⚠️ Some tests failed. Check the errors above.{Colors.END}\n")

if __name__ == "__main__":
    try:
        run_all_tests()
    except KeyboardInterrupt:
        print(f"\n\n{Colors.YELLOW}Tests interrupted by user.{Colors.END}\n")
    except Exception as e:
        print(f"\n{Colors.RED}Unexpected error: {str(e)}{Colors.END}\n")
