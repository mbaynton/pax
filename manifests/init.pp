class pax {
  stage { 'pax-repos':
    before => Stage['main'],
  }
}
