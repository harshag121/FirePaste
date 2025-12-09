import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '10s', target: 50 }, // Ramp up
    { duration: '30s', target: 50 }, // Stay at 50 users
    { duration: '10s', target: 0 },  // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% of requests must complete below 500ms
  },
};

export default function () {
  // 1. Create Paste
  const payload = {
    content: 'This is a load test paste ' + Math.random(),
    ttl: '5m',
  };

  const res = http.post('http://localhost:80/paste', payload);
  
  check(res, {
    'created status is 200': (r) => r.status === 200 || r.status === 201, // Depending on handler redirect
  });

  // Extract ID if possible - our handler redirects to /:id
  // k6 follows redirects by default, so we land on view page.
  // We can't easily parse HTML in k6 easily without libs, but status 200 on redirect is good enough.

  sleep(1);
}
