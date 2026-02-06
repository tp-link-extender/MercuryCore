<script lang="ts">
    const { data } = $props()
    console.log(data.assets)
</script>

<main>
  <!-- <slot /> -->
  <div class="container mx-auto">
    <h1 class="text-center">Toolbox</h1>
    <div class="container mx-auto mt-8 pb-16">
      <div id="all">
        {#each data.assets as asset}
          <a href="/place" class="game-link">
            <img src="/place/test.jpg" alt="place" />
            <div class="text">
              <p>le game</p>
            </div>
          </a>
        {/each}
      </div>
    </div>
  </div>
</main>

<style>
  .game-link {
    text-align: center;
    text-decoration: none;
    overflow: hidden;
    margin: none;
    width: 10rem;
    display: inline-block;
    margin: 0.5rem;
    color: light-text;
  }

  a {
    display: block;
    text-decoration: none;
  }

  fa {
    font-family: faSolid;
    color: grey-text;
    line-height: 1;
  }

  .text {
    background-color: darker;
    padding: 0.7rem;
    margin-top: -0.5rem;
    padding-bottom: 1.8rem;
  }

  p {
    margin: 0;
    margin-bottom: 0.5rem;
  }

  img {
    width: 10rem;
    height: 10rem;
  }

  #all {
    width: fit-content;
    text-align: center;
  }
</style>

<!-- {@html `
<script>
        document.getElementById("test").addEventListener("click", function() {
            try
            {
                window.external.Insert("http://mercs.dev/asset/?id=831133977");
            }
	        catch(x)
	        {
	            alert("Could not insert the requested item");
	        }
        });
</script>`
} -->
