pragma solidity 0.8.17;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract PokemonBattleContract is ERC721 {

    struct PokemonWallet{
        uint id;
        string logoUri;
        string name;
        uint level;
        uint value;
        uint life;
        string status;
        address owner;
        //_id, _logoUri, _name, _total_title, _level, _value, _status, gameOwner
    }

    PokemonWallet[] public pokemonWallets; //Array q guarda os dados do Pokemons Cards
    
    address public Owner;//variavel Owner guarda o hash da conta dono do jogo)
    address public contractAddress;

    
    //NOME DO TOKEN e o Simbolo
    constructor() ERC721("Treinador Token", "FTB"){
        Owner = msg.sender; //Guarda o hash da conta do usuário q fez o deploy
    }

    modifier onlyOwnerOf(uint _attacking){
        require(ownerOf(_attacking) == msg.sender, "Somente o dono pode batalhar");
        _;
    }

    function creatNewPokemon(string memory _logoUri, string  memory _name, uint _life, uint _value) public{
        require(msg.sender == Owner, "Somente o dono do jogo pode criar um novo Club!");
        uint _id = pokemonWallets.length;
        //pokemonWallet.push(PokemonWallet(_name,_life, 1));
        string memory _status = "disponivel";
        uint _level = 1;

        pokemonWallets.push(PokemonWallet(_id, _logoUri, _name, _level, _value,_life, _status, Owner));
        _safeMint(Owner, _id);
    }

    function battle(uint _attackingPokemon, uint _defendingPokemon) public onlyOwnerOf(_attackingPokemon){
        PokemonWallet storage attacker = pokemonWallets[_attackingPokemon];
        PokemonWallet storage defender = pokemonWallets[_defendingPokemon];

        if(attacker.level >= defender.level) {
            attacker.level += 2;
            defender.level += 1;
        }
        else{
            attacker.level += 1;
            defender.level += 2;
        }
    }

    function getPokemonWallet(uint _id) view public returns (PokemonWallet memory pokemonWallet ){
        for (uint index = 0; index < pokemonWallets.length; index++){
            if (pokemonWallets[index].id == _id){
                return pokemonWallets[index];                 
            }
        }        
    }

    function get_All_PokemonWallet() view public returns (PokemonWallet[] memory){
        return pokemonWallets;
    }
   
    function sendEth(address _user, uint _PokemonWallet_id) public payable {
       require(msg.value == pokemonWallets[_PokemonWallet_id].value);
       
       (bool didSend, ) = Owner.call{value: msg.value}("");
       pokemonWallets[_PokemonWallet_id].status = "vendido";
       pokemonWallets[_PokemonWallet_id].owner = _user;
           
       require(didSend);
   }
}