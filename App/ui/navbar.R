# Navbar
navbarPage(
  title = div(
    class="navbar-title", 
    div(
      a(img(src = "tmlogo.png", width = 130), href="https://www.transfermarkt.com/", target="_blank"), 
      "Contract Detector", icon("file-signature")
    )
  )
)