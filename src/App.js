import logo from './logo.svg';
import './App.css';
import Config from './config.json';

function App() {
  const TEST_VARIABLE = Config.TEST_VARIABLE;
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
        <p>Ma variable d'environnement { TEST_VARIABLE }</p>
      </header>
    </div>
  );
}

export default App;
