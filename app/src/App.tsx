import React from "react";
import {
  BrowserRouter as Router,
  Redirect,
  Route,
  Switch,
} from "react-router-dom";
import { v4 } from "uuid";
import "./App.css";
import SyncEditor from "./components/SyncEditor";

const App: React.FC = () => {
  return (
    <Router>
      <Switch>
        <Route path="/" exact>
          <Redirect to={`/docs?id=${v4()}`} />
        </Route>
        <Route path="/docs" exact>
          <SyncEditor />
        </Route>
      </Switch>
    </Router>
  );
};

export default App;
