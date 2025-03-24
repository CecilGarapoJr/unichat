const client = require('../index');

async function checkStatus() {
  try {
    console.log('Checking deployment status...');
    const status = await client.getStatus();
    console.log('Current status:', status);
  } catch (error) {
    console.error('Failed to get status:', error.message);
    process.exit(1);
  }
}

checkStatus();
