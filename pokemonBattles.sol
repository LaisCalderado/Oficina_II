pragma solidity 0.8.6;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract PokemonBattles is ERC721 {

    struct PokemonWallet{
        string name;
        uint life;
        uint level;
    }

    PokemonWallet[] public pokemonWallet; //Array q guarda os dados do Pokemons Cards
    address public Owner;//variavel Owner guarda o hash da conta dono do jogo)

    //NOME DO TOKEN e o Simbolo
    constructor() ERC721("Treinador Token", "FTB"){
        Owner = msg.sender; //Guarda o hash da conta do usuário q fez o deploy
    }

    modifier onlyOwnerOf(uint _attacking){
        require(ownerOf(_attacking) == msg.sender, "Somente o dono");
        _;
    }

    function creatNewPokemon(string  memory _name, uint _life, address _to) public{
        require(msg.sender == Owner, "Somente o dono do jogo pode criar um novo Club!");
        uint id = pokemonWallet.length;
        pokemonWallet.push(PokemonWallet(_name,_life, 1));
        _safeMint(_to, id);
    }

    function battle(uint _attackingPokemon, uint _defendingPokemon) public onlyOwnerOf(_attackingPokemon){
        PokemonWallet storage attacker = pokemonWallet[_attackingPokemon];
        PokemonWallet storage defender = pokemonWallet[_defendingPokemon];

        if(attacker.level >= defender.level) {
            attacker.level += 2;
            defender.level += 1;
        }
        else{
            attacker.level += 1;
            defender.level += 2;
        }
    }
}