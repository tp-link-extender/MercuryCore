<div class="loginForm py-8 mt-8">
  <div class="hero-text py-8 mt-8">
    <h1>Login to Mercury</h1>
    <small>Login to Mercury to create or update your places! <br> Don't have an account? <a href="https://mercs.dev">Sign up!</a></small>
  </div>
  <div class="login container mx-auto py-5">
    <form>
      <div class="form-group">
        <label for="username">Username</label>
        <input type="text" class="form-control" id="username" placeholder="Enter username"/>
      </div>
      <div class="form-group">
        <label for="password">Password</label>
        <input type="password" class="form-control" id="password" placeholder="Password"/>
      </div>
      <button type="submit">Login</button>
    </form>
  </div>
</div>

<style>
  :global(:root) {
    background: #1e1d20;
    color: #f4f2f7;
  }
  a {
    text-decoration: none;
    color: #8b52f0;
  }
  .hero-text {
    text-align: center;
  }
  .form-control {
    color: #f4f2f7;
    height: 40px;
    margin-bottom: 15px;
    padding: 10px;
    font-size: 16px;
    background-color: #0f0e11;
    border-radius: 5px;
    border: 1px solid #353338;
  }
  .login {
    width: 400px;
  }
  button {
    background-color: #6c2bee;
    color: #fff;
    border: none;
    padding: 15px 20px;
    font-size: 14px;
    border-radius: 5px;
    cursor: pointer;
    width: 100%;
    }
</style>
